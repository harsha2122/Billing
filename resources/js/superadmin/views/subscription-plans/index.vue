<template>
	<AdminPageHeader>
		<template #header>
			<a-page-header title="Subscription Plans" style="padding: 0">
				<template #extra>
					<a-button type="primary" @click="showAddModal">
						<template #icon><PlusOutlined /></template>
						Add Plan
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
						placeholder="Search plans..."
						style="width: 100%; max-width: 300px"
						@search="fetchPlans"
						allow-clear
					/>
				</a-col>
			</a-row>

			<a-table
				:columns="columns"
				:data-source="plans"
				:pagination="pagination"
				:loading="loading"
				:row-key="(record) => record.id"
				@change="handleTableChange"
			>
				<template #bodyCell="{ column, record }">
					<template v-if="column.dataIndex === 'modules'">
						<a-space wrap>
							<a-tag v-for="module in record.modules" :key="module" color="blue">
								{{ module }}
							</a-tag>
							<span v-if="!record.modules || record.modules.length === 0">-</span>
						</a-space>
					</template>
					<template v-if="column.dataIndex === 'max_products'">
						<a-tag color="green">{{ record.max_products }} products</a-tag>
					</template>
					<template v-if="column.dataIndex === 'created_at'">
						{{ formatDate(record.created_at) }}
					</template>
					<template v-if="column.dataIndex === 'action'">
						<a-space>
							<a-button
								type="link"
								size="small"
								@click="editPlan(record)"
							>
								<EditOutlined /> Edit
							</a-button>
							<a-button
								type="link"
								size="small"
								@click="viewPlan(record)"
							>
								<EyeOutlined /> View
							</a-button>
							<a-popconfirm
								title="Are you sure you want to delete this plan?"
								ok-text="Yes"
								cancel-text="No"
								@confirm="deletePlan(record.xid)"
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
			:title="isEdit ? 'Edit Subscription Plan' : 'Add New Subscription Plan'"
			:width="800"
			@ok="handleSubmit"
			@cancel="handleCancel"
		>
			<a-form :model="formData" layout="vertical">
				<a-row :gutter="16">
					<a-col :xs="24" :sm="12">
						<a-form-item label="Plan Name" required>
							<a-input v-model:value="formData.name" placeholder="e.g. Basic Plan" />
						</a-form-item>
					</a-col>
					<a-col :xs="24" :sm="12">
						<a-form-item label="Max Products" required>
							<a-input-number
								v-model:value="formData.max_products"
								:min="0"
								placeholder="Maximum products allowed"
								style="width: 100%"
							/>
						</a-form-item>
					</a-col>
				</a-row>

				<a-form-item label="Description">
					<a-textarea v-model:value="formData.description" :rows="3" placeholder="Plan description" />
				</a-form-item>

				<a-row :gutter="16">
					<a-col :xs="24" :sm="8">
						<a-form-item label="Max Users">
							<a-input-number
								v-model:value="formData.max_users"
								:min="0"
								placeholder="0 for unlimited"
								style="width: 100%"
							/>
						</a-form-item>
					</a-col>
					<a-col :xs="24" :sm="8">
						<a-form-item label="Max Warehouses">
							<a-input-number
								v-model:value="formData.max_warehouses"
								:min="1"
								placeholder="Number of warehouses"
								style="width: 100%"
							/>
						</a-form-item>
					</a-col>
				</a-row>

				<a-row :gutter="16">
					<a-col :xs="24" :sm="12">
						<a-form-item label="Monthly Price">
							<a-input-number
								v-model:value="formData.monthly_price"
								:min="0"
								:precision="2"
								placeholder="0.00"
								style="width: 100%"
							/>
						</a-form-item>
					</a-col>
					<a-col :xs="24" :sm="12">
						<a-form-item label="Annual Price">
							<a-input-number
								v-model:value="formData.annual_price"
								:min="0"
								:precision="2"
								placeholder="0.00"
								style="width: 100%"
							/>
						</a-form-item>
					</a-col>
				</a-row>

				<a-form-item label="Modules">
					<a-checkbox-group v-model:value="formData.modules" style="width: 100%">
						<a-row>
							<a-col :xs="12" :sm="8" v-for="module in availableModules" :key="module.value">
								<a-checkbox :value="module.value">{{ module.label }}</a-checkbox>
							</a-col>
						</a-row>
					</a-checkbox-group>
				</a-form-item>
			</a-form>
		</a-modal>

		<!-- View Modal -->
		<a-modal
			v-model:visible="viewModalVisible"
			title="Subscription Plan Details"
			:width="700"
			:footer="null"
		>
			<a-descriptions bordered :column="{ xs: 1, sm: 2 }" v-if="viewingPlan">
				<a-descriptions-item label="Plan Name" :span="2">
					{{ viewingPlan.name }}
				</a-descriptions-item>
				<a-descriptions-item label="Description" :span="2">
					{{ viewingPlan.description || '-' }}
				</a-descriptions-item>
				<a-descriptions-item label="Max Products">
					{{ viewingPlan.max_products }}
				</a-descriptions-item>
				<a-descriptions-item label="Max Users">
					{{ viewingPlan.max_users || 'Unlimited' }}
				</a-descriptions-item>
				<a-descriptions-item label="Max Warehouses">
					{{ viewingPlan.max_warehouses }}
				</a-descriptions-item>
				<a-descriptions-item label="Monthly Price">
					${{ viewingPlan.monthly_price || 0 }}
				</a-descriptions-item>
				<a-descriptions-item label="Annual Price">
					${{ viewingPlan.annual_price || 0 }}
				</a-descriptions-item>
				<a-descriptions-item label="Companies Using" v-if="viewingStats">
					{{ viewingStats.companies_count }}
				</a-descriptions-item>
				<a-descriptions-item label="Modules" :span="2">
					<a-space wrap>
						<a-tag v-for="module in viewingPlan.modules" :key="module" color="blue">
							{{ module }}
						</a-tag>
						<span v-if="!viewingPlan.modules || viewingPlan.modules.length === 0">None</span>
					</a-space>
				</a-descriptions-item>
				<a-descriptions-item label="Created At" :span="2">
					{{ formatDate(viewingPlan.created_at) }}
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
		const plans = ref([]);
		const loading = ref(false);
		const modalVisible = ref(false);
		const viewModalVisible = ref(false);
		const isEdit = ref(false);
		const searchText = ref("");
		const viewingPlan = ref(null);
		const viewingStats = ref(null);

		const pagination = ref({
			current: 1,
			pageSize: 10,
			total: 0,
		});

		const formData = ref({
			name: "",
			description: "",
			max_products: 100,
			max_users: 0,
			max_warehouses: 1,
			monthly_price: 0,
			annual_price: 0,
			modules: [],
		});

		const availableModules = ref([
			{ label: "POS", value: "pos" },
			{ label: "Stock Transfer", value: "stock_transfer" },
			{ label: "Stock Adjustment", value: "stock_adjustment" },
			{ label: "Sales Return", value: "sales_return" },
			{ label: "Purchase Return", value: "purchase_return" },
			{ label: "Quotation", value: "quotation" },
			{ label: "Expense", value: "expense" },
			{ label: "Online Store", value: "online_store" },
		]);

		const columns = [
			{
				title: "Plan Name",
				dataIndex: "name",
				key: "name",
			},
			{
				title: "Max Products",
				dataIndex: "max_products",
				key: "max_products",
			},
			{
				title: "Modules",
				dataIndex: "modules",
				key: "modules",
			},
			{
				title: "Created",
				dataIndex: "created_at",
				key: "created_at",
			},
			{
				title: "Action",
				dataIndex: "action",
				key: "action",
			},
		];

		const fetchPlans = async () => {
			loading.value = true;
			try {
				const response = await axiosAdmin.get("/superadmin/subscription-plans", {
					params: {
						page: pagination.value.current,
						per_page: pagination.value.pageSize,
						search: searchText.value,
					},
				});
				plans.value = response.data.data;
				pagination.value.total = response.data.total;
			} catch (error) {
				message.error("Failed to fetch subscription plans");
			} finally {
				loading.value = false;
			}
		};

		const handleTableChange = (paginationData) => {
			pagination.value.current = paginationData.current;
			pagination.value.pageSize = paginationData.pageSize;
			fetchPlans();
		};

		const showAddModal = () => {
			isEdit.value = false;
			formData.value = {
				name: "",
				description: "",
				max_products: 100,
				max_users: 0,
				max_warehouses: 1,
				monthly_price: 0,
				annual_price: 0,
				modules: [],
			};
			modalVisible.value = true;
		};

		const editPlan = (plan) => {
			isEdit.value = true;
			formData.value = {
				xid: plan.xid,
				name: plan.name,
				description: plan.description,
				max_products: plan.max_products,
				max_users: plan.max_users,
				max_warehouses: plan.max_warehouses,
				monthly_price: plan.monthly_price,
				annual_price: plan.annual_price,
				modules: plan.modules || [],
			};
			modalVisible.value = true;
		};

		const viewPlan = async (plan) => {
			try {
				const response = await axiosAdmin.get(`/superadmin/subscription-plans/${plan.xid}`);
				viewingPlan.value = response.data.plan;
				viewingStats.value = {
					companies_count: response.data.companies_count
				};
				viewModalVisible.value = true;
			} catch (error) {
				message.error("Failed to load plan details");
			}
		};

		const handleSubmit = async () => {
			try {
				if (isEdit.value) {
					await axiosAdmin.put(
						`/superadmin/subscription-plans/${formData.value.xid}`,
						formData.value
					);
					message.success("Subscription plan updated successfully");
				} else {
					await axiosAdmin.post("/superadmin/subscription-plans", formData.value);
					message.success("Subscription plan created successfully");
				}
				modalVisible.value = false;
				fetchPlans();
			} catch (error) {
				message.error(error.response?.data?.message || "Failed to save subscription plan");
			}
		};

		const deletePlan = async (xid) => {
			try {
				await axiosAdmin.delete(`/superadmin/subscription-plans/${xid}`);
				message.success("Subscription plan deleted successfully");
				fetchPlans();
			} catch (error) {
				message.error(error.response?.data?.message || "Failed to delete subscription plan");
			}
		};

		const handleCancel = () => {
			modalVisible.value = false;
			formData.value = {
				name: "",
				description: "",
				max_products: 100,
				max_users: 0,
				max_warehouses: 1,
				monthly_price: 0,
				annual_price: 0,
				modules: [],
			};
		};

		const formatDate = (date) => {
			return date ? dayjs(date).format("YYYY-MM-DD HH:mm") : "-";
		};

		onMounted(() => {
			fetchPlans();
		});

		return {
			plans,
			loading,
			modalVisible,
			viewModalVisible,
			isEdit,
			searchText,
			pagination,
			formData,
			columns,
			availableModules,
			viewingPlan,
			viewingStats,
			fetchPlans,
			handleTableChange,
			showAddModal,
			editPlan,
			viewPlan,
			handleSubmit,
			deletePlan,
			handleCancel,
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
