import { createRouter, createWebHistory } from 'vue-router';
import store from '../store';
import AuthRoutes from './auth';
import DashboardRoutes from './dashboard';
import ProductRoutes from './products';
import StockRoutes from './stocks';
import ExpensesRoutes from './expenses';
import UserRoutes from './users';
import SettingRoutes from './settings';
import ReportsRoutes from './reports';
import SetupAppRoutes from './setupApp';
import { checkUserPermission } from '../../common/scripts/functions';
import FrontRoutes from './front';
import WebsiteSetupRoutes from './websiteSetup';

const appType = window.config.app_type;
const allActiveModules = window.config.modules;
const allInstalledModules = window.config.installed_modules;
var allModulesRoutes = [];

const checkAllRoutes = (currentModuleRoutes, allModule) => {
    currentModuleRoutes.forEach((eachRoute) => {

        if (eachRoute.meta) {
            eachRoute.meta.appModule = allModule;
        }

        if (eachRoute.children) {
            var allChildrenRoues = eachRoute.children;

            checkAllRoutes(allChildrenRoues, allModule);
        }
    })
}

if (allInstalledModules && allInstalledModules.length > 0) {
    allInstalledModules.forEach((allModule) => {
        try {
            const allModuleName = allModule.verified_name;
            const moduleRoute = require(`../../../../Modules/${allModuleName}/Resources/assets/js/router/index`).default;
            var currentModuleRoutes = [...moduleRoute];

            checkAllRoutes(currentModuleRoutes, allModuleName);

            allModulesRoutes.push(...currentModuleRoutes);
        } catch (error) {
            console.warn('Module router not found:', allModule.verified_name);
        }
    });
}

// Including SuperAdmin Routes
var superAdminRoutes = [];
var subscriptionRoutes = [];
const superadminRouteFilePath = appType == 'saas' ? 'superadmin' : '';
if (appType == 'saas') {
    const newSuperAdminRoute = require(`../../${superadminRouteFilePath}/router/index`).default
    superAdminRoutes = [...newSuperAdminRoute];

    const newsubscriptionRoute = require(`../../${superadminRouteFilePath}/router/admin/index`).default
    subscriptionRoutes = [...newsubscriptionRoute];
}

const isAdminCompanySetupCorrect = () => {
    var appSetting = store.state.auth.appSetting;

    if (appSetting.x_currency_id == null || appSetting.x_warehouse_id == null) {
        return false;
    }

    return true;
}

const router = createRouter({
    history: createWebHistory(),
    routes: [
        ...allModulesRoutes,
        ...FrontRoutes,
        {
            path: '',
            redirect: '/admin/login'
        },
        ...WebsiteSetupRoutes,
        ...ProductRoutes,
        ...StockRoutes,
        ...ExpensesRoutes,
        ...AuthRoutes,
        ...DashboardRoutes,
        ...UserRoutes,
        ...ReportsRoutes,
        ...SettingRoutes,
        ...subscriptionRoutes,
        ...superAdminRoutes,
        ...SetupAppRoutes,
        {
            path: "/:catchAll(.*)",
            redirect: '/'
        }
    ],
    scrollBehavior: () => ({ left: 0, top: 0 }),
});

router.beforeEach((to, from, next) => {
    // Check Module Access
    if (to.meta.appModule) {
        if (Array.isArray(allActiveModules) && !allActiveModules.includes(to.meta.appModule)) {
            return next({ name: 'admin.dashboard.index' });
        }
    }

    // Front Routes Auth
    if (to.name && to.name.startsWith('front.') && to.meta.requireAuth && !store.getters['front/isLoggedIn']) {
        store.dispatch('front/logout');
        return next({ name: 'front.homepage' });
    }

    // Admin/Superadmin Auth
    if (to.meta.requireAuth || to.meta.requireUnauth) {
        const isLoggedIn = store.getters['auth/isLoggedIn'];
        const user = store.state.auth.user;

        if (to.meta.requireUnauth && isLoggedIn) {
            return next({ name: 'admin.dashboard.index' });
        }

        if (to.meta.requireAuth && !isLoggedIn) {
            return next({ name: 'admin.login' });
        }

        if (to.meta.requireAuth && isLoggedIn) {
            // Check Company Setup
            if (!isAdminCompanySetupCorrect() && to.name !== 'admin.setup_app.index' && to.name !== 'admin.logout') {
                return next({ name: 'admin.setup_app.index' });
            }

            // Check Permissions
            if (to.meta.permission) {
                const permission = to.meta.permission.replace(/-/g, '_');
                if (!checkUserPermission(permission, user)) {
                    return next({ name: 'admin.dashboard.index' });
                }
            }
        }
    }

    next();
});

export default router
