import Admin from "../../common/layouts/Admin.vue";
import Dashboard from "../views/dashboard/index.vue";
import Companies from "../views/companies/index.vue";
import SubscriptionPlans from "../views/subscription-plans/index.vue";

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
					menuParent: "superadmin-dashboard",
					menuKey: "superadmin-dashboard",
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
			{
				path: "subscription-plans",
				component: SubscriptionPlans,
				name: "superadmin.subscription-plans.index",
				meta: {
					requireAuth: true,
					requiresSuperAdmin: true,
					menuParent: "subscription-plans",
					menuKey: "subscription-plans",
				},
			},
		],
	},
];
