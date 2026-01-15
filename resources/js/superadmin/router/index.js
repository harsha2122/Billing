import SuperAdminLayout from "../layouts/SuperAdminLayout.vue";
import Dashboard from "../views/dashboard/index.vue";
import Companies from "../views/companies/index.vue";

export default [
	{
		path: "/superadmin",
		component: SuperAdminLayout,
		meta: {
			requiresAuth: true,
			requiresSuperAdmin: true,
		},
		children: [
			{
				path: "",
				redirect: "/superadmin/dashboard",
			},
			{
				path: "dashboard",
				component: Dashboard,
				name: "superadmin.dashboard",
				meta: {
					requiresAuth: true,
					requiresSuperAdmin: true,
					menuKey: "superadmin_dashboard",
				},
			},
			{
				path: "companies",
				component: Companies,
				name: "superadmin.companies.index",
				meta: {
					requiresAuth: true,
					requiresSuperAdmin: true,
					menuKey: "superadmin_companies",
				},
			},
		],
	},
];
