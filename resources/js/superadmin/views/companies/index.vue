<template>
	<AdminPageHeader>
		<template #header>
			<a-page-header title="Companies Management" style="padding: 0">
				<template #extra>
					<a-button type="primary" @click="showAddModal">
						<template #icon><PlusOutlined /></template>
						Add Company
					</a-button>
				</template>
			</a-page-header>
		</template>
	</AdminPageHeader>

	<div class="dashboard-page-content-container">
		<a-card>
			<a-row class="mb-10">
				<a-col :span="24">
					<a-input-search
						v-model:value="searchText"
						placeholder="Search companies..."
						style="width: 100%; max-width: 300px"
						@search="fetchCompanies"
						allow-clear
					/>
				</a-col>
			</a-row>

			<a-table
				:columns="columns"
				:data-source="companies"
				:pagination="pagination"
				:loading="loading"
				:row-key="(record) => record.id"
				@change="handleTableChange"
			>
				<template #bodyCell="{ column, record }">
					<template v-if="column.dataIndex === 'business_type'">
						<a-tag v-if="record.business_type" :color="getBusinessTypeColor(record.business_type)">
							{{ record.business_type }}
						</a-tag>
						<span v-else>-</span>
					</template>
					<template v-if="column.dataIndex === 'status'">
						<a-tag :color="getStatusColor(record.status)">
							{{ record.status }}
						</a-tag>
					</template>
					<template v-if="column.dataIndex === 'admin'">
						<div v-if="record.admin">
							<div>{{ record.admin.name }}</div>
							<div style="font-size: 12px; color: #999">
								{{ record.admin.email }}
							</div>
						</div>
						<span v-else>-</span>
					</template>
					<template v-if="column.dataIndex === 'created_at'">
						{{ formatDate(record.created_at) }}
					</template>
					<template v-if="column.dataIndex === 'action'">
						<a-space>
							<a-button
								type="link"
								size="small"
								@click="editCompany(record)"
							>
								<EditOutlined /> Edit
							</a-button>
							<a-button
								type="link"
								size="small"
								@click="viewCompany(record)"
							>
								<EyeOutlined /> View
							</a-button>
							<a-popconfirm
								title="Are you sure you want to delete this company?"
								ok-text="Yes"
								cancel-text="No"
								@confirm="deleteCompany(record.xid)"
							>
								<a-button type="link" size="small" danger>
									<DeleteOutlined /> Delete
								</a-button>
							</a-popconfirm>
						</a-space>
					</template>
				</template>
			</a-table>
		</a-card>

		<!-- Add/Edit Modal -->
		<a-modal
			v-model:visible="modalVisible"
			:title="isEdit ? 'Edit Company' : 'Add New Company'"
			:width="700"
			@ok="handleSubmit"
			@cancel="handleCancel"
		>
			<a-form :model="formData" layout="vertical">
				<a-row :gutter="16">
					<a-col :xs="24" :sm="12">
						<a-form-item label="Company Name" required>
							<a-input v-model:value="formData.name" placeholder="Enter company name" />
						</a-form-item>
					</a-col>
					<a-col :xs="24" :sm="12">
						<a-form-item label="Short Name">
							<a-input v-model:value="formData.short_name" placeholder="Enter short name" />
						</a-form-item>
					</a-col>
				</a-row>
				<a-row :gutter="16">
					<a-col :xs="24" :sm="12">
						<a-form-item label="Business Type" required>
							<a-select v-model:value="formData.business_type" placeholder="Select business type">
								<a-select-option value="wholesaler">Wholesaler</a-select-option>
								<a-select-option value="distributor">Distributor</a-select-option>
								<a-select-option value="retailer">Retailer</a-select-option>
								<a-select-option value="manufacturer">Manufacturer</a-select-option>
							</a-select>
						</a-form-item>
					</a-col>
					<a-col :xs="24" :sm="12">
						<a-form-item label="Email" required>
							<a-input v-model:value="formData.email" type="email" placeholder="company@example.com" />
						</a-form-item>
					</a-col>
				</a-row>
				<a-row :gutter="16">
					<a-col :xs="24" :sm="12">
						<a-form-item label="Phone">
							<a-input v-model:value="formData.phone" placeholder="+1234567890" />
						</a-form-item>
					</a-col>
					<a-col :xs="24" :sm="12">
						<a-form-item label="Max Devices Allowed">
							<a-input-number v-model:value="formData.max_devices" :min="1" :max="100" placeholder="1" style="width: 100%" />
						</a-form-item>
					</a-col>
				</a-row>
				<a-form-item label="Address">
					<a-textarea v-model:value="formData.address" :rows="2" placeholder="Enter address" />
				</a-form-item>

				<template v-if="!isEdit">
					<a-form-item label="Subscription Plan" required>
						<a-select
							v-model:value="formData.subscription_plan_id"
							placeholder="Select a subscription plan"
							:loading="plansLoading"
						>
							<a-select-option
								v-for="plan in subscriptionPlans"
								:key="plan.xid"
								:value="plan.xid"
							>
								{{ plan.name }} (Max {{ plan.max_products }} products)
							</a-select-option>
						</a-select>
					</a-form-item>
				</template>

				<template v-if="isEdit">
					<a-form-item label="Status" required>
						<a-select v-model:value="formData.status">
							<a-select-option value="active">Active</a-select-option>
							<a-select-option value="inactive">Inactive</a-select-option>
							<a-select-option value="license_expired">License Expired</a-select-option>
						</a-select>
					</a-form-item>
				</template>

				<template v-if="!isEdit">
					<a-divider>Admin Details</a-divider>
					<a-row :gutter="16">
						<a-col :xs="24" :sm="12">
							<a-form-item label="Admin Name" required>
								<a-input v-model:value="formData.admin_name" placeholder="Admin name" />
							</a-form-item>
						</a-col>
						<a-col :xs="24" :sm="12">
							<a-form-item label="Admin Email" required>
								<a-input v-model:value="formData.admin_email" type="email" placeholder="admin@example.com" />
							</a-form-item>
						</a-col>
					</a-row>
					<a-form-item label="Admin Password" required>
						<a-input-password v-model:value="formData.admin_password" placeholder="Minimum 6 characters" />
					</a-form-item>
				</template>
			</a-form>
		</a-modal>

		<!-- View Modal -->
		<a-modal
			v-model:visible="viewModalVisible"
			title="Company Details"
			:width="800"
			:footer="null"
		>
			<a-descriptions bordered :column="{ xs: 1, sm: 2 }" v-if="viewingCompany">
				<a-descriptions-item label="Company Name" :span="2">
					{{ viewingCompany.name }}
				</a-descriptions-item>
				<a-descriptions-item label="Business Type">
					<a-tag v-if="viewingCompany.business_type" :color="getBusinessTypeColor(viewingCompany.business_type)">
						{{ viewingCompany.business_type }}
					</a-tag>
					<span v-else>-</span>
				</a-descriptions-item>
				<a-descriptions-item label="Email">
					{{ viewingCompany.email }}
				</a-descriptions-item>
				<a-descriptions-item label="Phone">
					{{ viewingCompany.phone || '-' }}
				</a-descriptions-item>
				<a-descriptions-item label="Max Devices">
					{{ viewingCompany.max_devices || 1 }}
				</a-descriptions-item>
				<a-descriptions-item label="Address" :span="2">
					{{ viewingCompany.address || '-' }}
				</a-descriptions-item>
				<a-descriptions-item label="Status">
					<a-tag :color="getStatusColor(viewingCompany.status)">
						{{ viewingCompany.status }}
					</a-tag>
				</a-descriptions-item>
				<a-descriptions-item label="Created At">
					{{ formatDate(viewingCompany.created_at) }}
				</a-descriptions-item>
				<a-descriptions-item label="Admin Name">
					{{ viewingCompany.admin ? viewingCompany.admin.name : '-' }}
				</a-descriptions-item>
				<a-descriptions-item label="Admin Email">
					{{ viewingCompany.admin ? viewingCompany.admin.email : '-' }}
				</a-descriptions-item>
				<a-descriptions-item label="Warehouse">
					{{ viewingCompany.warehouse ? viewingCompany.warehouse.name : '-' }}
				</a-descriptions-item>
				<a-descriptions-item label="Currency">
					{{ viewingCompany.currency ? viewingCompany.currency.code : '-' }}
				</a-descriptions-item>
				<a-descriptions-item label="Total Users" v-if="viewingStats">
					{{ viewingStats.total_users }}
				</a-descriptions-item>
				<a-descriptions-item label="Total Products" v-if="viewingStats">
					{{ viewingStats.total_products }}
				</a-descriptions-item>
				<a-descriptions-item label="Total Orders" v-if="viewingStats">
					{{ viewingStats.total_orders }}
				</a-descriptions-item>
			</a-descriptions>
		</a-modal>
	</div>
</template>

<script>
import { defineComponent, ref, onMounted } from "vue";
import {
	PlusOutlined,
	EditOutlined,
	DeleteOutlined,
	EyeOutlined,
} from "@ant-design/icons-vue";
import { message } from "ant-design-vue";
import dayjs from "dayjs";
import AdminPageHeader from "../../../common/layouts/AdminPageHeader.vue";
import axiosAdmin from "../../../common/plugins/axiosAdmin";

export default defineComponent({
	components: {
		PlusOutlined,
		EditOutlined,
		DeleteOutlined,
		EyeOutlined,
		AdminPageHeader,
	},
	setup() {
		const companies = ref([]);
		const loading = ref(false);
		const modalVisible = ref(false);
		const viewModalVisible = ref(false);
		const isEdit = ref(false);
		const searchText = ref("");
		const viewingCompany = ref(null);
		const viewingStats = ref(null);
		const subscriptionPlans = ref([]);
		const plansLoading = ref(false);

		const pagination = ref({
			current: 1,
			pageSize: 10,
			total: 0,
		});

		const formData = ref({
			name: "",
			short_name: "",
			business_type: null,
			max_devices: 1,
			email: "",
			phone: "",
			address: "",
			subscription_plan_id: null,
			admin_name: "",
			admin_email: "",
			admin_password: "",
			status: "active",
		});

		const routes = [
			{
				path: "/",
				breadcrumbName: "Home",
			},
			{
				path: "/superadmin/companies",
				breadcrumbName: "Companies",
			},
		];

		const columns = [
			{
				title: "Company Name",
				dataIndex: "name",
			},
			{
				title: "Business Type",
				dataIndex: "business_type",
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
				width: 250,
			},
		];

		const fetchCompanies = () => {
			loading.value = true;
			axiosAdmin
				.get("superadmin/companies", {
					params: {
						page: pagination.value.current,
						per_page: pagination.value.pageSize,
						search: searchText.value,
					},
				})
				.then((response) => {
					companies.value = response.data.data;
					pagination.value.total = response.data.total;
				})
				.catch((error) => {
					message.error("Failed to fetch companies");
					console.error(error);
				})
				.finally(() => {
					loading.value = false;
				});
		};

		const handleTableChange = (pag) => {
			pagination.value.current = pag.current;
			pagination.value.pageSize = pag.pageSize;
			fetchCompanies();
		};

		const showAddModal = () => {
			isEdit.value = false;
			modalVisible.value = true;
			resetForm();
		};

		const editCompany = (record) => {
			isEdit.value = true;
			formData.value = {
				xid: record.xid,
				name: record.name,
				short_name: record.short_name,
				business_type: record.business_type,
				max_devices: record.max_devices,
				email: record.email,
				phone: record.phone,
				address: record.address,
				status: record.status,
			};
			modalVisible.value = true;
		};

		const viewCompany = (record) => {
			loading.value = true;
			axiosAdmin
				.get(`superadmin/companies/${record.xid}`)
				.then((response) => {
					viewingCompany.value = response.data.company;
					viewingStats.value = response.data.stats;
					viewModalVisible.value = true;
				})
				.catch((error) => {
					message.error("Failed to fetch company details");
					console.error(error);
				})
				.finally(() => {
					loading.value = false;
				});
		};

		const handleSubmit = () => {
			if (isEdit.value) {
				// Update
				axiosAdmin
					.put(`superadmin/companies/${formData.value.xid}`, formData.value)
					.then(() => {
						message.success("Company updated successfully");
						modalVisible.value = false;
						fetchCompanies();
					})
					.catch((error) => {
						message.error("Failed to update company");
						console.error(error);
					});
			} else {
				// Create
				axiosAdmin
					.post("superadmin/companies", formData.value)
					.then(() => {
						message.success("Company created successfully");
						modalVisible.value = false;
						fetchCompanies();
						resetForm();
					})
					.catch((error) => {
						message.error(
							error.response?.data?.message || "Failed to create company"
						);
						console.error(error);
					});
			}
		};

		const deleteCompany = (xid) => {
			axiosAdmin
				.delete(`superadmin/companies/${xid}`)
				.then(() => {
					message.success("Company deleted successfully");
					fetchCompanies();
				})
				.catch((error) => {
					message.error("Failed to delete company");
					console.error(error);
				});
		};

		const handleCancel = () => {
			modalVisible.value = false;
			resetForm();
		};

		const resetForm = () => {
			formData.value = {
				name: "",
				short_name: "",
				business_type: null,
				max_devices: 1,
				email: "",
				phone: "",
				address: "",
				subscription_plan_id: null,
				admin_name: "",
				admin_email: "",
				admin_password: "",
				status: "active",
			};
		};

		const getStatusColor = (status) => {
			const colors = {
				active: "green",
				inactive: "orange",
				license_expired: "red",
			};
			return colors[status] || "default";
		};

		const getBusinessTypeColor = (type) => {
			const colors = {
				wholesaler: "blue",
				distributor: "purple",
				retailer: "cyan",
				manufacturer: "volcano",
			};
			return colors[type] || "default";
		};

		const formatDate = (date) => {
			return dayjs(date).format("DD-MM-YYYY HH:mm");
		};

		const fetchSubscriptionPlans = () => {
			plansLoading.value = true;
			axiosAdmin
				.get("superadmin/subscription-plans-all")
				.then((response) => {
					subscriptionPlans.value = response.data.plans;
				})
				.catch((error) => {
					message.error("Failed to fetch subscription plans");
					console.error(error);
				})
				.finally(() => {
					plansLoading.value = false;
				});
		};

		onMounted(() => {
			fetchCompanies();
			fetchSubscriptionPlans();
		});

		return {
			companies,
			loading,
			modalVisible,
			viewModalVisible,
			isEdit,
			searchText,
			pagination,
			formData,
			routes,
			columns,
			viewingCompany,
			viewingStats,
			subscriptionPlans,
			plansLoading,
			fetchCompanies,
			fetchSubscriptionPlans,
			handleTableChange,
			showAddModal,
			editCompany,
			viewCompany,
			handleSubmit,
			deleteCompany,
			handleCancel,
			getStatusColor,
			getBusinessTypeColor,
			formatDate,
		};
	},
});
</script>

<style scoped>
.mb-10 {
	margin-bottom: 10px;
}
</style>
