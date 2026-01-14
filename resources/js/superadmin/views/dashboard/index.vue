<template>
	<div>
		<a-page-header
			title="SuperAdmin Dashboard"
			:breadcrumb="{ routes }"
			style="padding: 0; margin-bottom: 20px"
		/>

		<a-row :gutter="[16, 16]">
			<a-col :xs="24" :sm="12" :md="6">
				<a-card>
					<a-statistic
						title="Total Companies"
						:value="stats.total_companies"
						:prefix="$createElement('ShopOutlined')"
					/>
				</a-card>
			</a-col>
			<a-col :xs="24" :sm="12" :md="6">
				<a-card>
					<a-statistic
						title="Active Companies"
						:value="stats.active_companies"
						:prefix="$createElement('CheckCircleOutlined')"
						:value-style="{ color: '#3f8600' }"
					/>
				</a-card>
			</a-col>
			<a-col :xs="24" :sm="12" :md="6">
				<a-card>
					<a-statistic
						title="Total Users"
						:value="stats.total_users"
						:prefix="$createElement('UserOutlined')"
					/>
				</a-card>
			</a-col>
			<a-col :xs="24" :sm="12" :md="6">
				<a-card>
					<a-statistic
						title="Total Orders"
						:value="stats.total_orders"
						:prefix="$createElement('ShoppingCartOutlined')"
					/>
				</a-card>
			</a-col>
		</a-row>

		<a-row :gutter="[16, 16]" class="mt-20">
			<a-col :xs="24" :sm="12" :md="6">
				<a-card>
					<a-statistic
						title="Total Products"
						:value="stats.total_products"
						:prefix="$createElement('InboxOutlined')"
					/>
				</a-card>
			</a-col>
			<a-col :xs="24" :sm="12" :md="18">
				<a-card>
					<a-statistic
						title="Total Sales"
						:value="stats.total_sales"
						:prefix="$createElement('DollarOutlined')"
						:precision="2"
						:value-style="{ color: '#1890ff' }"
					/>
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
import { defineComponent, ref, onMounted, createVNode } from "vue";
import {
	ShopOutlined,
	CheckCircleOutlined,
	UserOutlined,
	ShoppingCartOutlined,
	InboxOutlined,
	DollarOutlined,
} from "@ant-design/icons-vue";
import dayjs from "dayjs";

export default defineComponent({
	components: {
		ShopOutlined,
		CheckCircleOutlined,
		UserOutlined,
		ShoppingCartOutlined,
		InboxOutlined,
		DollarOutlined,
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
		const routes = [
			{
				path: "/",
				breadcrumbName: "Home",
			},
			{
				path: "/superadmin/dashboard",
				breadcrumbName: "Dashboard",
			},
		];

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
			routes,
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
