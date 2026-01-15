<template>
	<AdminPageHeader>
		<template #header>
			<a-page-header :title="$t('menu.dashboard')" style="padding: 0px" />
		</template>
	</AdminPageHeader>

	<div class="dashboard-page-content-container">

		<a-row :gutter="[16, 16]">
			<a-col :xs="24" :sm="12" :md="6">
				<a-card>
					<a-statistic
						title="Total Companies"
						:value="stats.total_companies"
					>
						<template #prefix>
							<ShopOutlined />
						</template>
					</a-statistic>
				</a-card>
			</a-col>
			<a-col :xs="24" :sm="12" :md="6">
				<a-card>
					<a-statistic
						title="Active Companies"
						:value="stats.active_companies"
						:value-style="{ color: '#3f8600' }"
					>
						<template #prefix>
							<CheckCircleOutlined />
						</template>
					</a-statistic>
				</a-card>
			</a-col>
			<a-col :xs="24" :sm="12" :md="6">
				<a-card>
					<a-statistic
						title="Total Users"
						:value="stats.total_users"
					>
						<template #prefix>
							<UserOutlined />
						</template>
					</a-statistic>
				</a-card>
			</a-col>
			<a-col :xs="24" :sm="12" :md="6">
				<a-card>
					<a-statistic
						title="Total Orders"
						:value="stats.total_orders"
					>
						<template #prefix>
							<ShoppingCartOutlined />
						</template>
					</a-statistic>
				</a-card>
			</a-col>
		</a-row>

		<a-row :gutter="[16, 16]" class="mt-20">
			<a-col :xs="24" :sm="12" :md="6">
				<a-card>
					<a-statistic
						title="Total Products"
						:value="stats.total_products"
					>
						<template #prefix>
							<InboxOutlined />
						</template>
					</a-statistic>
				</a-card>
			</a-col>
			<a-col :xs="24" :sm="12" :md="18">
				<a-card>
					<a-statistic
						title="Total Sales"
						:value="stats.total_sales"
						:precision="2"
						:value-style="{ color: '#1890ff' }"
					>
						<template #prefix>
							<DollarOutlined />
						</template>
					</a-statistic>
				</a-card>
			</a-col>
		</a-row>

		<a-card class="mt-20" title="Recent Companies">
			<a-table
				:columns="columns"
				:data-source="recentCompanies"
				:pagination="false"
				:row-key="(record) => record.id"
			>
				<template #bodyCell="{ column, record }">
					<template v-if="column.dataIndex === 'status'">
						<a-tag :color="record.status === 'active' ? 'green' : 'red'">
							{{ record.status }}
						</a-tag>
					</template>
					<template v-if="column.dataIndex === 'admin'">
						{{ record.admin ? record.admin.name : '-' }}
					</template>
					<template v-if="column.dataIndex === 'created_at'">
						{{ formatDate(record.created_at) }}
					</template>
					<template v-if="column.dataIndex === 'action'">
						<router-link :to="{ name: 'superadmin.companies.edit', params: { id: record.xid } }">
							<a-button type="link" size="small">View</a-button>
						</router-link>
					</template>
				</template>
			</a-table>
		</a-card>
	</div>
</template>

<script>
import { defineComponent, ref, onMounted } from "vue";
import {
	ShopOutlined,
	CheckCircleOutlined,
	UserOutlined,
	ShoppingCartOutlined,
	InboxOutlined,
	DollarOutlined,
} from "@ant-design/icons-vue";
import dayjs from "dayjs";
import AdminPageHeader from "../../../common/layouts/AdminPageHeader.vue";

export default defineComponent({
	components: {
		ShopOutlined,
		CheckCircleOutlined,
		UserOutlined,
		ShoppingCartOutlined,
		InboxOutlined,
		DollarOutlined,
		AdminPageHeader,
	},
	setup() {
		const stats = ref({
			total_companies: 0,
			active_companies: 0,
			total_users: 0,
			total_products: 0,
			total_orders: 0,
			total_sales: 0,
		});
		const recentCompanies = ref([]);

		const columns = [
			{
				title: "Company Name",
				dataIndex: "name",
			},
			{
				title: "Email",
				dataIndex: "email",
			},
			{
				title: "Admin",
				dataIndex: "admin",
			},
			{
				title: "Status",
				dataIndex: "status",
			},
			{
				title: "Created At",
				dataIndex: "created_at",
			},
			{
				title: "Action",
				dataIndex: "action",
			},
		];

		const fetchStats = () => {
			axiosAdmin
				.get("superadmin/dashboard/stats")
				.then((response) => {
					stats.value = response.data.stats;
					recentCompanies.value = response.data.recent_companies;
				})
				.catch((error) => {
					console.error("Error fetching stats:", error);
				});
		};

		const formatDate = (date) => {
			return dayjs(date).format("DD-MM-YYYY");
		};

		onMounted(() => {
			fetchStats();
		});

		return {
			stats,
			recentCompanies,
			columns,
			formatDate,
		};
	},
});
</script>

<style scoped>
.mt-20 {
	margin-top: 20px;
}
</style>
