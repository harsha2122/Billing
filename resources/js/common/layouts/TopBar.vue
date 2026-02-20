<template>
    <a-layout-header class="topbar-menu bg-color" :style="{ padding: '0 16px' }">
        <a-row :wrap="false">
            <a-col :xs="4" :sm="8" :md="8" :lg="8" style="min-width: 0; overflow: hidden;">
                <div class="topbar-left">
                    <MenuOutlined class="trigger" @click="showHideMenu" />
                    <span v-if="appSetting && appSetting.name" class="topbar-company-info">
                        <strong>{{ appSetting.name }}</strong>
                        <a-tag v-if="appSetting.business_type" size="small" :style="{ marginLeft: '6px', fontSize: '11px', textTransform: 'capitalize', flexShrink: 0 }">{{ appSetting.business_type }}</a-tag>
                    </span>
                </div>
            </a-col>
            <a-col :xs="20" :sm="16" :md="16" :lg="16">
                <HeaderRightIcons>
                    <a-space>
                        <template
                            v-if="
                                innerWidth > 768 &&
                                (permsArray.includes('pos_view') ||
                                    permsArray.includes('admin')) &&
                                willSubscriptionModuleVisible('pos')
                            "
                        >
                            <a-button
                                @click="
                                    () => {
                                        $router.push({ name: 'admin.pos.index' });
                                    }
                                "
                                type="link"
                            >
                                <ShoppingCartOutlined />
                                <span>{{ $t("menu.pos") }}</span>
                            </a-button>
                            <a-divider type="vertical" />
                        </template>
                        <template v-if="selectedWarehouse && selectedWarehouse.name">
                            <template v-if="appSetting.shortcut_menus != 'bottom'">
                                <AffixButton position="top" />
                                <a-divider type="vertical" />
                            </template>
                            <ChangeWarehouse />
                            <a-divider type="vertical" />
                        </template>
                        <a-dropdown
                            :placement="appSetting.rtl ? 'bottomLeft' : 'bottomRight'"
                        >
                            <a class="ant-dropdown-link" @click.prevent>
                                {{ selectedLang }}
                                <DownOutlined />
                            </a>
                            <template #overlay>
                                <a-menu>
                                    <a-menu-item
                                        v-for="lang in langs"
                                        :key="lang.key"
                                        @click="langSelected(lang.key)"
                                    >
                                        <a-space>
                                            <a-avatar
                                                shape="square"
                                                size="small"
                                                :src="lang.image_url"
                                            />
                                            {{ lang.name }}
                                        </a-space>
                                    </a-menu-item>
                                </a-menu>
                            </template>
                        </a-dropdown>
                        <a-divider type="vertical" />
                        <a-button
                            type="link"
                            @click="
                                () => {
                                    $router.push({
                                        name: 'admin.settings.profile.index',
                                    });
                                }
                            "
                            class="p-0"
                        >
                            <a-avatar size="small" :src="user.profile_image_url" />
                        </a-button>
                    </a-space>
                </HeaderRightIcons>
            </a-col>
        </a-row>
    </a-layout-header>
</template>

<script>
import { ref, reactive, computed, onMounted } from "vue";
import { useStore } from "vuex";
import { MenuOutlined, DownOutlined, ShoppingCartOutlined } from "@ant-design/icons-vue";
import { useI18n } from "vue-i18n";
import { loadLocaleMessages } from "../i18n";
import { HeaderRightIcons } from "./style";
import common from "../../common/composable/common";
import MenuMode from "./MenuMode.vue";
import ChangeWarehouse from "./ChangeWarehouse.vue";
import AffixButton from "./AffixButton.vue";

export default {
    components: {
        MenuOutlined,
        DownOutlined,
        HeaderRightIcons,
        MenuMode,
        ChangeWarehouse,
        AffixButton,
        ShoppingCartOutlined,
    },
    setup(props, { emit }) {
        const {
            user,
            appSetting,
            permsArray,
            menuCollapsed,
            willSubscriptionModuleVisible,
            selectedWarehouse,
        } = common();
        const store = useStore();
        const selectedLang = ref(store.state.auth.lang);
        const { locale, t } = useI18n();
        const themeMode = ref(window.config.theme_mode == "light" ? false : true);
        const themeModeLoading = ref(false);

        const langSelected = async (lang) => {
            store.commit("auth/updateLang", lang);
            await loadLocaleMessages(i18n, lang);

            selectedLang.value = lang;
            locale.value = lang;
        };

        const showHideMenu = () => {
            store.commit("auth/updateMenuCollapsed", !menuCollapsed.value);
        };

        const logout = () => {
            store.dispatch("auth/logout");
        };

        const themeModeChanged = (checked) => {
            const mode = checked ? "dark" : "light";
            themeModeLoading.value = true;

            axiosAdmin
                .post("change-theme-mode", {
                    theme_mode: mode,
                })
                .then((response) => {
                    if (response.data.status == "success") {
                        window.location.reload();
                    }
                    themeModeLoading.value = false;
                });
        };

        return {
            selectedWarehouse,
            permsArray,
            appSetting,
            willSubscriptionModuleVisible,
            logout,
            showHideMenu,
            langSelected,
            selectedLang,
            langs: computed(() => store.state.auth.allLangs),

            user,

            themeMode,
            themeModeChanged,
            themeModeLoading,

            innerWidth: window.innerWidth,
        };
    },
};
</script>

<style lang="less">
.trigger {
    font-size: 18px;
    line-height: 64px;
    padding-top: 4px;
    cursor: pointer;
    transition: color 0.3s;
}

.trigger:hover {
    color: #1890ff;
}

.topbar-left {
    display: flex;
    align-items: center;
    gap: 8px;
    height: 64px;
    min-width: 0;
    overflow: hidden;
}

.topbar-company-info {
    display: flex;
    align-items: center;
    font-size: 14px;
    min-width: 0;
    overflow: hidden;

    strong {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        min-width: 0;
    }
}

/* Hide company name on mobile — hamburger icon only */
@media (max-width: 575px) {
    .topbar-company-info {
        display: none;
    }
}
</style>
