import Dashboard from "../views/dashboard/index.vue";
import Companies from "../views/companies/index.vue";

export default [
	{
		path: "/superadmin",
		redirect: "/superadmin/dashboard",
		meta: {
			requiresAuth: true,
			requiresSuperAdmin: true,
		},
	},
	{
		path: "/superadmin/dashboard",
		component: Dashboard,
		name: "superadmin.dashboard",
		meta: {
			requiresAuth: true,
			requiresSuperAdmin: true,
			menuKey: "superadmin_dashboard",
		},
	},
	{
		path: "/superadmin/companies",
		component: Companies,
		name: "superadmin.companies.index",
		meta: {
			requiresAuth: true,
			requiresSuperAdmin: true,
			menuKey: "superadmin_companies",
		},
	},
];
