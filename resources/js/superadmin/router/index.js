import Admin from "../../common/layouts/Admin.vue";
import Dashboard from "../../main/views/Dashboard.vue";
import Companies from "../views/companies/index.vue";

export default [
	{
		path: "/superadmin",
		component: Admin,
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
					requireAuth: true,
					requiresSuperAdmin: true,
					menuParent: "dashboard",
					menuKey: "dashboard",
				},
			},
			{
				path: "companies",
				component: Companies,
				name: "superadmin.companies.index",
				meta: {
					requireAuth: true,
					requiresSuperAdmin: true,
					menuParent: "companies",
					menuKey: "companies",
				},
			},
		],
	},
];
