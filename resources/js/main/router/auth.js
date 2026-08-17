import Login from '../views/auth/Login.vue';
import ForgotPassword from '../views/auth/ForgotPassword.vue';

export default [
    {
        path: '/admin/login',
        component: Login,
        name: 'admin.login',
        meta: {
            requireUnauth: true,
            menuKey: route => "login",
        }
    },
    {
        path: '/admin/forgot-password',
        component: ForgotPassword,
        name: 'admin.forgot-password',
        meta: {
            requireUnauth: true,
            menuKey: route => "login",
        }
    },
]
