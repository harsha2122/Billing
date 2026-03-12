<template>
	<AdminPageHeader>
		<template #header>
			<a-page-header :title="$t('product.bulk_barcode_print')" class="p-0" />
		</template>
		<template #breadcrumb>
			<a-breadcrumb separator="-" style="font-size: 12px">
				<a-breadcrumb-item>
					<router-link :to="{ name: 'admin.dashboard.index' }">
						{{ $t("menu.dashboard") }}
					</router-link>
				</a-breadcrumb-item>
				<a-breadcrumb-item>
					{{ $t("menu.product_manager") }}
				</a-breadcrumb-item>
				<a-breadcrumb-item>
					{{ $t("product.bulk_barcode_print") }}
				</a-breadcrumb-item>
			</a-breadcrumb>
		</template>
	</AdminPageHeader>

	<a-row :gutter="[16, 16]" class="page-content-container">
		<!-- Left Panel: Product Selection -->
		<a-col :xs="24" :sm="24" :md="14" :lg="15" :xl="16">
			<a-card :title="$t('product.select_products')">
				<!-- Filters -->
				<a-row :gutter="[12, 12]" class="mb-20">
					<a-col :xs="24" :sm="12" :md="8">
						<a-input-search
							v-model:value="searchString"
							show-search
							@change="fetchProducts"
							@search="fetchProducts"
							style="width: 100%"
							:loading="loading"
							:placeholder="$t('common.search')"
						/>
					</a-col>
					<a-col :xs="24" :sm="12" :md="8">
						<a-select
							v-model:value="filterBrandId"
							:placeholder="$t('common.select_default_text', [$t('product.brand')])"
							:allowClear="true"
							style="width: 100%"
							optionFilterProp="title"
							show-search
							@change="fetchProducts"
						>
							<a-select-option
								v-for="brand in brands"
								:key="brand.xid"
								:title="brand.name"
								:value="brand.xid"
							>
								{{ brand.name }}
							</a-select-option>
						</a-select>
					</a-col>
					<a-col :xs="24" :sm="12" :md="8">
						<a-tree-select
							v-model:value="filterCategoryId"
							show-search
							style="width: 100%"
							:dropdown-style="{ maxHeight: '250px', overflow: 'auto' }"
							:placeholder="$t('common.select_default_text', [$t('category.category')])"
							:tree-data="categories"
							allow-clear
							tree-default-expand-all
							:filterTreeNode="filterTreeNode"
							@change="fetchProducts"
						/>
					</a-col>
				</a-row>

				<!-- Select All & Add Selected -->
				<a-row class="mb-10" justify="space-between" align="middle">
					<a-col>
						<a-checkbox
							:checked="isAllSelected"
							:indeterminate="isIndeterminate"
							@change="toggleSelectAll"
						>
							{{ $t("common.select_all") }} ({{ selectedProducts.length }} {{ $t("product.selected") }})
						</a-checkbox>
					</a-col>
					<a-col>
						<a-button
							type="primary"
							:disabled="selectedProducts.length === 0"
							@click="addSelectedToQueue"
						>
							<PlusOutlined />
							{{ $t("product.add_to_print_list") }}
						</a-button>
					</a-col>
				</a-row>

				<!-- Product Table -->
				<div class="table-responsive">
					<a-table
						:columns="productColumns"
						:row-key="(record) => record.xid"
						:data-source="products"
						:loading="loading"
						:pagination="pagination"
						@change="handleTableChange"
						bordered
						size="small"
					>
						<template #bodyCell="{ column, record }">
							<template v-if="column.dataIndex === 'select'">
								<a-checkbox
									:checked="selectedProducts.some(p => p.xid === record.xid)"
									@change="toggleProduct(record)"
								/>
							</template>
							<template v-if="column.dataIndex === 'name'">
								<a-space>
									<a-avatar shape="square" :src="record.image_url" />
									{{ record.name }}
								</a-space>
							</template>
							<template v-if="column.dataIndex === 'item_code'">
								<a-tag>{{ record.item_code }}</a-tag>
							</template>
							<template v-if="column.dataIndex === 'category_id'">
								{{ record.category ? record.category.name : '-' }}
							</template>
							<template v-if="column.dataIndex === 'brand_id'">
								{{ record.brand ? record.brand.name : '-' }}
							</template>
						</template>
					</a-table>
				</div>
			</a-card>
		</a-col>

		<!-- Right Panel: Print Queue & Settings -->
		<a-col :xs="24" :sm="24" :md="10" :lg="9" :xl="8">
			<a-card :title="$t('product.print_settings')" class="mb-16">
				<a-form layout="vertical">
					<a-form-item :label="$t('product.label_size')">
						<a-radio-group v-model:value="labelSize" button-style="solid" style="width:100%">
							<a-radio-button value="small" style="width:33%;text-align:center">{{ $t("product.small") }}</a-radio-button>
							<a-radio-button value="medium" style="width:34%;text-align:center">{{ $t("product.medium") }}</a-radio-button>
							<a-radio-button value="large" style="width:33%;text-align:center">{{ $t("product.large") }}</a-radio-button>
						</a-radio-group>
					</a-form-item>
					<a-form-item :label="$t('product.columns_per_row')">
						<a-radio-group v-model:value="columnsPerRow" button-style="solid">
							<a-radio-button :value="2">2</a-radio-button>
							<a-radio-button :value="3">3</a-radio-button>
							<a-radio-button :value="4">4</a-radio-button>
						</a-radio-group>
					</a-form-item>
					<a-form-item :label="$t('product.show_price')">
						<a-switch v-model:checked="showPrice" />
					</a-form-item>
					<a-form-item :label="$t('product.show_product_name')">
						<a-switch v-model:checked="showProductName" />
					</a-form-item>
				</a-form>
			</a-card>

			<!-- Print Queue -->
			<a-card :title="`${$t('product.print_list')} (${printQueue.length})`">
				<template #extra>
					<a-space>
						<a-button
							v-if="printQueue.length > 0"
							danger
							size="small"
							@click="printQueue = []"
						>
							{{ $t("common.clear_all") }}
						</a-button>
						<a-button
							type="primary"
							:disabled="printQueue.length === 0"
							@click="printBarcodes"
						>
							<PrinterOutlined />
							{{ $t("product.print_barcode") }}
						</a-button>
					</a-space>
				</template>

				<div v-if="printQueue.length === 0" class="empty-queue">
					<a-empty :description="$t('product.no_products_in_print_list')" />
				</div>

				<div v-for="item in printQueue" :key="item.xid" class="queue-item">
					<a-row align="middle" :gutter="8">
						<a-col :span="10">
							<div class="queue-product-name">{{ item.name }}</div>
							<div class="queue-item-code">{{ item.item_code }}</div>
						</a-col>
						<a-col :span="8">
							<a-input-number
								v-model:value="item.quantity"
								:min="1"
								:max="500"
								size="small"
								style="width: 100%"
								:addonBefore="$t('product.qty')"
							/>
						</a-col>
						<a-col :span="6" style="text-align:right">
							<a-button
								type="text"
								danger
								size="small"
								@click="removeFromQueue(item.xid)"
							>
								<DeleteOutlined />
							</a-button>
						</a-col>
					</a-row>
					<a-divider style="margin: 8px 0" />
				</div>
			</a-card>
		</a-col>
	</a-row>

	<!-- Hidden Print Area -->
	<div id="bulkBarcodePrintArea" style="display: none">
		<div class="bulk-print-page">
			<template v-for="item in printQueue" :key="item.xid">
				<div
					v-for="n in item.quantity"
					:key="`${item.xid}-${n}`"
					:class="['barcode-label', `label-${labelSize}`]"
					:style="{ width: `${Math.floor(100 / columnsPerRow)}%` }"
				>
					<vue-barcode
						:value="item.item_code + ''"
						:options="barcodeOptions"
						tag="svg"
					/>
					<div v-if="showProductName" class="label-product-name">{{ item.name }}</div>
					<div v-if="showPrice && item.details" class="label-price">
						{{ formatAmountCurrency(item.details.sales_price) }}
					</div>
				</div>
			</template>
		</div>
	</div>
</template>

<script>
import { ref, computed, onMounted } from "vue";
import {
	PlusOutlined,
	PrinterOutlined,
	DeleteOutlined,
	BarcodeOutlined,
} from "@ant-design/icons-vue";
import AdminPageHeader from "../../../../common/layouts/AdminPageHeader.vue";
import common from "../../../../common/composable/common";

export default {
	components: {
		AdminPageHeader,
		PlusOutlined,
		PrinterOutlined,
		DeleteOutlined,
		BarcodeOutlined,
	},
	setup() {
		const {
			permsArray,
			formatAmountCurrency,
			getRecursiveCategories,
			filterTreeNode,
		} = common();

		// Filters
		const searchString = ref("");
		const filterBrandId = ref(undefined);
		const filterCategoryId = ref(undefined);

		// Data
		const products = ref([]);
		const categories = ref([]);
		const brands = ref([]);
		const loading = ref(false);
		const pagination = ref({ current: 1, pageSize: 10, total: 0 });

		// Selection
		const selectedProducts = ref([]);

		// Print queue
		const printQueue = ref([]);

		// Settings
		const labelSize = ref("medium");
		const columnsPerRow = ref(3);
		const showPrice = ref(true);
		const showProductName = ref(true);

		const productColumns = [
			{
				title: "",
				dataIndex: "select",
				width: 40,
			},
			{
				title: "Product",
				dataIndex: "name",
			},
			{
				title: "Barcode",
				dataIndex: "item_code",
			},
			{
				title: "Category",
				dataIndex: "category_id",
			},
			{
				title: "Brand",
				dataIndex: "brand_id",
			},
		];

		const barcodeOptions = computed(() => {
			const heightMap = { small: 40, medium: 60, large: 80 };
			return { height: heightMap[labelSize.value], displayValue: true };
		});

		const isAllSelected = computed(() => {
			return (
				products.value.length > 0 &&
				products.value.every((p) =>
					selectedProducts.value.some((s) => s.xid === p.xid)
				)
			);
		});

		const isIndeterminate = computed(() => {
			return (
				selectedProducts.value.some((s) =>
					products.value.some((p) => p.xid === s.xid)
				) && !isAllSelected.value
			);
		});

		const fetchProducts = () => {
			loading.value = true;
			const params = {
				fields: "id,xid,name,item_code,barcode_symbology,image_url,category_id,x_category_id,category{id,xid,name},brand_id,x_brand_id,brand{id,xid,name},details{sales_price}",
				limit: pagination.value.pageSize,
				page: pagination.value.current,
			};

			if (searchString.value) params.search = searchString.value;
			if (filterBrandId.value) params["filters[brand_id]"] = filterBrandId.value;
			if (filterCategoryId.value) params["filters[category_id]"] = filterCategoryId.value;

			axiosAdmin
				.get("products", { params })
				.then((response) => {
					products.value = response.data.data || response.data;
					if (response.data.meta) {
						pagination.value.total = response.data.meta.total;
					}
				})
				.finally(() => {
					loading.value = false;
				});
		};

		const handleTableChange = (pag) => {
			pagination.value.current = pag.current;
			pagination.value.pageSize = pag.pageSize;
			fetchProducts();
		};

		const toggleProduct = (product) => {
			const idx = selectedProducts.value.findIndex((p) => p.xid === product.xid);
			if (idx === -1) {
				selectedProducts.value.push(product);
			} else {
				selectedProducts.value.splice(idx, 1);
			}
		};

		const toggleSelectAll = (e) => {
			if (e.target.checked) {
				products.value.forEach((p) => {
					if (!selectedProducts.value.some((s) => s.xid === p.xid)) {
						selectedProducts.value.push(p);
					}
				});
			} else {
				selectedProducts.value = selectedProducts.value.filter(
					(s) => !products.value.some((p) => p.xid === s.xid)
				);
			}
		};

		const addSelectedToQueue = () => {
			selectedProducts.value.forEach((product) => {
				if (!printQueue.value.some((q) => q.xid === product.xid)) {
					printQueue.value.push({ ...product, quantity: 1 });
				}
			});
			selectedProducts.value = [];
		};

		const removeFromQueue = (xid) => {
			printQueue.value = printQueue.value.filter((q) => q.xid !== xid);
		};

		const printBarcodes = () => {
			const printContent = document.getElementById("bulkBarcodePrintArea").innerHTML;
			const printWindow = window.open("", "", "height=800,width=900");

			printWindow.document.write(`
				<!DOCTYPE html>
				<html>
				<head>
					<title>Bulk Barcode Print</title>
					<style>
						* { margin: 0; padding: 0; box-sizing: border-box; }
						body { font-family: Arial, sans-serif; }
						.bulk-print-page {
							display: flex;
							flex-wrap: wrap;
							padding: 10px;
						}
						.barcode-label {
							display: inline-flex;
							flex-direction: column;
							align-items: center;
							justify-content: center;
							border: 1px dashed #ccc;
							padding: 4px;
							page-break-inside: avoid;
						}
						.label-small { height: 80px; }
						.label-medium { height: 110px; }
						.label-large { height: 140px; }
						.label-small svg { height: 40px !important; }
						.label-medium svg { height: 60px !important; }
						.label-large svg { height: 80px !important; }
						.label-product-name {
							font-size: 10px;
							font-weight: bold;
							text-align: center;
							margin-top: 2px;
							max-width: 100%;
							overflow: hidden;
							text-overflow: ellipsis;
							white-space: nowrap;
						}
						.label-price {
							font-size: 10px;
							color: #333;
							text-align: center;
						}
						@media print {
							body { margin: 0; }
							.bulk-print-page { padding: 5px; }
						}
					</style>
				</head>
				<body>${printContent}</body>
				</html>
			`);
			printWindow.document.close();
			printWindow.focus();
			setTimeout(() => {
				printWindow.print();
				printWindow.close();
			}, 500);
		};

		onMounted(() => {
			const categoriesPromise = axiosAdmin.get("categories?limit=10000");
			const brandsPromise = axiosAdmin.get("brands?limit=10000");

			Promise.all([categoriesPromise, brandsPromise]).then(
				([categoriesResponse, brandsResponse]) => {
					categories.value = getRecursiveCategories(categoriesResponse);
					brands.value = brandsResponse.data;
				}
			);

			fetchProducts();
		});

		return {
			permsArray,
			formatAmountCurrency,
			filterTreeNode,

			searchString,
			filterBrandId,
			filterCategoryId,

			products,
			categories,
			brands,
			loading,
			pagination,
			productColumns,

			selectedProducts,
			isAllSelected,
			isIndeterminate,
			toggleProduct,
			toggleSelectAll,

			printQueue,
			addSelectedToQueue,
			removeFromQueue,
			printBarcodes,

			labelSize,
			columnsPerRow,
			showPrice,
			showProductName,
			barcodeOptions,

			fetchProducts,
			handleTableChange,
		};
	},
};
</script>

<style lang="less" scoped>
.page-content-container {
	padding: 20px;
}

.mb-16 {
	margin-bottom: 16px;
}

.mb-20 {
	margin-bottom: 20px;
}

.mb-10 {
	margin-bottom: 10px;
}

.empty-queue {
	padding: 20px 0;
}

.queue-item {
	.queue-product-name {
		font-size: 13px;
		font-weight: 600;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
	.queue-item-code {
		font-size: 11px;
		color: #888;
	}
}

/* Print area layout used inside printBarcodes() */
#bulkBarcodePrintArea {
	.bulk-print-page {
		display: flex;
		flex-wrap: wrap;
	}
	.barcode-label {
		display: inline-flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		border: 1px dashed #ccc;
		padding: 4px;
	}
}
</style>
