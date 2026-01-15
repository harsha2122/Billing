<template>
    <a-layout-header class="topbar-menu bg-color" :style="{ padding: '0 16px' }">
        <a-row>
            <a-col :span="4">
                <a-space>
                    <MenuOutlined class="trigger" @click="showHideMenu" />
                </a-space>
            </a-col>
            <a-col :span="20">
                <HeaderRightIcons>
                    <a-space>
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
                            class="p-0"
                        >
                            <a-avatar size="small" :src="user.profile_image_url" />
                            <span style="margin-left: 8px;">{{ user.name }}</span>
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
import { MenuOutlined, DownOutlined } from "@ant-design/icons-vue";
import { useI18n } from "vue-i18n";
import { loadLocaleMessages } from "../../common/i18n";
import { HeaderRightIcons } from "../../common/layouts/style";
import common from "../../common/composable/common";

export default {
    components: {
        MenuOutlined,
        DownOutlined,
        HeaderRightIcons,
    },
    setup() {
        const store = useStore();
        const { user, appSetting, menuCollapsed } = common();
        const { locale } = useI18n({
            useScope: "global",
        });

        const langs = ref([]);
        const selectedLang = computed(() => {
            return langs.value.find((lang) => lang.key == locale.value)
                ? langs.value.find((lang) => lang.key == locale.value).name
                : "English";
        });

        onMounted(() => {
            const langsModule = window.config.langs;
            langs.value = langsModule ? langsModule : [];
        });

        const langSelected = (key) => {
            loadLocaleMessages(key);
            locale.value = key;
            localStorage.setItem("user_lang", key);
        };

        const showHideMenu = () => {
            store.commit("auth/updateMenuCollapsed", !menuCollapsed.value);
        };

        return {
            user,
            appSetting,
            langs,
            selectedLang,
            langSelected,
            showHideMenu,
            innerWidth: window.innerWidth,
        };
    },
};
</script>
