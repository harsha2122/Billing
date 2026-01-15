<template>
    <Div>
        <section id="components-layout-demo-responsive">
            <a-layout>
                <SuperAdminSidebar />

                <a-layout>
                    <MainArea
                        :innerWidth="innerWidth"
                        :collapsed="menuCollapsed"
                        :isRtl="appSetting.rtl"
                    >
                        <SuperAdminTopBar />
                        <MainContentArea>
                            <a-layout-content>
                                <router-view></router-view>
                            </a-layout-content>
                        </MainContentArea>
                    </MainArea>
                </a-layout>
            </a-layout>
        </section>
    </Div>
</template>

<script>
import { ref } from "vue";
import SuperAdminTopBar from "./SuperAdminTopBar.vue";
import SuperAdminSidebar from "./SuperAdminSidebar.vue";
import { Div, MainArea, MainContentArea } from "../../common/layouts/style";
import common from "../../common/composable/common";

export default {
    components: {
        SuperAdminTopBar,
        SuperAdminSidebar,
        Div,
        MainArea,
        MainContentArea,
    },
    setup() {
        const { appSetting, menuCollapsed } = common();

        return {
            appSetting,
            menuCollapsed,
            innerWidth: window.innerWidth,
        };
    },
};
</script>

<style>
#components-layout-demo-responsive .logo {
    height: 32px;
    margin: 16px;
    text-align: center;
}

.site-layout-sub-header-background {
    background: #fff;
}

.site-layout-background {
    background: #fff;
}

[data-theme="dark"] .site-layout-sub-header-background {
    background: #141414;
}
</style>
