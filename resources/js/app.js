require('./common/plugins');

import { createApp } from 'vue';
import Antd from 'ant-design-vue';
import PerfectScrollbar from 'vue3-perfect-scrollbar';
import App from './main/views/App.vue';
import routes from './main/router'
import store from './main/store';
import { setupI18n, loadLocaleMessages } from './common/i18n';

import 'vue3-perfect-scrollbar/dist/vue3-perfect-scrollbar.css';
import VueBarcode from '@chenfengyuan/vue-barcode';
import print from 'vue3-print-nb';

async function bootstrap() {
    // Force dismiss loader after 5 seconds as a safety measure
    const timeout = setTimeout(() => {
        console.warn("Bootstrap timeout - forcing loader dismissal");
        store.commit("auth/updateAppChecking", false);
    }, 5000);

    try {
        if (store.getters["auth/isLoggedIn"]) {
            await store.dispatch("auth/updateUser");
        }

        await Promise.all([
            store.dispatch("auth/updateGlobalSetting"),
            store.dispatch("auth/updateApp"),
            store.dispatch("auth/updateAllLangs"),
            store.dispatch("auth/updateAllWarehouses"),
            store.dispatch("auth/updateVisibleSubscriptionModules")
        ]);

        store.commit("auth/updateActiveModules", window.config.modules);
    } catch (error) {
        console.error("Error during app initialization:", error);
    } finally {
        clearTimeout(timeout);
        store.commit("auth/updateAppChecking", false);
    }

    const app = createApp(App);

    const i18n = setupI18n({ legacy: false, globalInjection: true, locale: store.state.auth.lang, warnHtmlMessage: false });
    await loadLocaleMessages(i18n, store.state.auth.lang);

    // app.config.devtools = true;
    // app.config.debug = true;

    app.use(i18n);
    app.use(Antd);
    app.use(PerfectScrollbar)
    app.use(store);
    app.use(routes);
    app.use(print);

    app.component(VueBarcode.name, VueBarcode);
    const allModules = window.config.installed_modules;
    if (allModules && allModules.length > 0) {
        allModules.forEach((allModule) => {
            try {
                const moduleName = allModule.verified_name;
                const moduleMenu = require(`../../Modules/${moduleName}/Resources/assets/js/views/menu/admin.vue`)
                    .default;

                app.component(moduleName + 'Menu', moduleMenu);
            } catch (error) {
                console.warn('Module not found:', allModule.verified_name);
            }
        });
    }

    window.i18n = i18n;

    app.mount("#app");
}

bootstrap();



