<template>
	<AdminPageHeader>
		<template #header>
			<a-page-header title="Bulk Barcode Print" class="p-0" />
		</template>
		<template #breadcrumb>
			<a-breadcrumb separator="-" style="font-size: 12px">
				<a-breadcrumb-item>
					<router-link :to="{ name: 'admin.dashboard.index' }">
						{{ $t("menu.dashboard") }}
					</router-link>
				</a-breadcrumb-item>
				<a-breadcrumb-item>{{ $t("menu.product_manager") }}</a-breadcrumb-item>
				<a-breadcrumb-item>Bulk Barcode Print</a-breadcrumb-item>
			</a-breadcrumb>
		</template>
	</AdminPageHeader>

	<a-row :gutter="[16, 16]" class="page-content-container">

		<!-- ─── LEFT: Product Selection ──────────────────────────── -->
		<a-col :xs="24" :sm="24" :md="14" :lg="15" :xl="16">
			<a-card title="Select Products">
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
							placeholder="Search products…"
						/>
					</a-col>
					<a-col :xs="24" :sm="12" :md="8">
						<a-select
							v-model:value="filterBrandId"
							placeholder="Filter by Brand"
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
							placeholder="Filter by Category"
							:tree-data="categories"
							allow-clear
							tree-default-expand-all
							:filterTreeNode="filterTreeNode"
							@change="fetchProducts"
						/>
					</a-col>
				</a-row>

				<!-- Select All row -->
				<a-row class="mb-10" justify="space-between" align="middle">
					<a-col>
						<a-checkbox
							:checked="isAllSelected"
							:indeterminate="isIndeterminate"
							@change="toggleSelectAll"
						>
							Select All
							<a-tag v-if="selectedProducts.length > 0" color="blue" style="margin-left:4px">
								{{ selectedProducts.length }} selected
							</a-tag>
						</a-checkbox>
					</a-col>
					<a-col>
						<a-button
							type="primary"
							:disabled="selectedProducts.length === 0"
							@click="addSelectedToQueue"
						>
							<PlusOutlined /> Add to Print List
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

		<!-- ─── RIGHT: Settings + Queue ─────────────────────────── -->
		<a-col :xs="24" :sm="24" :md="10" :lg="9" :xl="8">

			<!-- Print Settings -->
			<a-card title="Print Settings" class="mb-16">
				<a-form layout="vertical">
					<a-form-item label="Label Size">
						<a-radio-group v-model:value="labelSize" button-style="solid" style="width:100%">
							<a-radio-button value="small"  style="width:33%;text-align:center">Small</a-radio-button>
							<a-radio-button value="medium" style="width:34%;text-align:center">Medium</a-radio-button>
							<a-radio-button value="large"  style="width:33%;text-align:center">Large</a-radio-button>
						</a-radio-group>
					</a-form-item>
					<a-form-item label="Columns Per Row">
						<a-radio-group v-model:value="columnsPerRow" button-style="solid">
							<a-radio-button :value="2">2 col</a-radio-button>
							<a-radio-button :value="3">3 col</a-radio-button>
							<a-radio-button :value="4">4 col</a-radio-button>
						</a-radio-group>
					</a-form-item>
					<a-row :gutter="16">
						<a-col :span="12">
							<a-form-item label="Show Price">
								<a-switch v-model:checked="showPrice" />
							</a-form-item>
						</a-col>
						<a-col :span="12">
							<a-form-item label="Show Name">
								<a-switch v-model:checked="showProductName" />
							</a-form-item>
						</a-col>
					</a-row>
				</a-form>

				<!-- ── Live Layout Preview ── -->
				<a-divider style="margin: 8px 0 12px">Layout Preview</a-divider>
				<div class="preview-sheet">
					<div
						v-for="cell in previewCells"
						:key="cell"
						:class="['preview-label', `preview-${labelSize}`]"
						:style="{ width: `${Math.floor(100 / columnsPerRow)}%` }"
					>
						<!-- mock barcode stripes -->
						<div class="mock-barcode">
							<span
								v-for="i in 18"
								:key="i"
								:class="['bar', i % 3 === 0 ? 'wide' : i % 5 === 0 ? 'gap' : '']"
							/>
						</div>
						<div class="mock-code">123456789</div>
						<div v-if="showProductName" class="mock-name">Product Name</div>
						<div v-if="showPrice" class="mock-price">₹ 299.00</div>
					</div>
				</div>
				<div class="preview-hint">
					{{ columnsPerRow }} column{{ columnsPerRow > 1 ? 's' : '' }} · {{ labelSizeLabel }} label
				</div>
			</a-card>

			<!-- Print Queue -->
			<a-card :title="`Print List (${printQueue.length} product${printQueue.length !== 1 ? 's' : ''})`">
				<template #extra>
					<a-space>
						<a-button
							v-if="printQueue.length > 0"
							danger
							size="small"
							@click="printQueue = []"
						>
							Clear All
						</a-button>
						<a-button
							type="primary"
							:disabled="printQueue.length === 0"
							@click="printBarcodes"
						>
							<PrinterOutlined /> Print Barcodes
						</a-button>
					</a-space>
				</template>

				<div v-if="printQueue.length === 0" class="empty-queue">
					<a-empty description="No products added yet. Select products and click 'Add to Print List'." />
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
								addon-before="Qty"
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

	<!-- ─── Hidden Print Area ─────────────────────────────────── -->
	<div id="bulkBarcodePrintArea" style="display:none">
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
} from "@ant-design/icons-vue";
import AdminPageHeader from "../../../../common/layouts/AdminPageHeader.vue";
import common from "../../../../common/composable/common";

export default {
	components: {
		AdminPageHeader,
		PlusOutlined,
		PrinterOutlined,
		DeleteOutlined,
	},
	setup() {
		const { permsArray, formatAmountCurrency, getRecursiveCategories, filterTreeNode } = common();

		const searchString    = ref("");
		const filterBrandId   = ref(undefined);
		const filterCategoryId = ref(undefined);

		const products   = ref([]);
		const categories = ref([]);
		const brands     = ref([]);
		const loading    = ref(false);
		const pagination = ref({ current: 1, pageSize: 10, total: 0 });

		const selectedProducts = ref([]);
		const printQueue       = ref([]);

		const labelSize      = ref("medium");
		const columnsPerRow  = ref(3);
		const showPrice      = ref(true);
		const showProductName = ref(true);

		// ── preview ──────────────────────────────────────────────
		const previewCells = computed(() => columnsPerRow.value * 2);

		const labelSizeLabel = computed(() => ({
			small: "Small (40px)", medium: "Medium (60px)", large: "Large (80px)",
		}[labelSize.value]));

		// ── table columns ─────────────────────────────────────────
		const productColumns = [
			{ title: "",         dataIndex: "select",      width: 40 },
			{ title: "Product",  dataIndex: "name" },
			{ title: "Barcode",  dataIndex: "item_code" },
			{ title: "Category", dataIndex: "category_id" },
			{ title: "Brand",    dataIndex: "brand_id" },
		];

		const barcodeOptions = computed(() => ({
			height: { small: 40, medium: 60, large: 80 }[labelSize.value],
			displayValue: true,
		}));

		// ── selection helpers ─────────────────────────────────────
		const isAllSelected = computed(() =>
			products.value.length > 0 &&
			products.value.every(p => selectedProducts.value.some(s => s.xid === p.xid))
		);

		const isIndeterminate = computed(() =>
			selectedProducts.value.some(s => products.value.some(p => p.xid === s.xid)) &&
			!isAllSelected.value
		);

		// ── data fetch ────────────────────────────────────────────
		const fetchProducts = () => {
			loading.value = true;
			const params = {
				fields: "id,xid,name,item_code,barcode_symbology,image_url,category_id,x_category_id,category{id,xid,name},brand_id,x_brand_id,brand{id,xid,name},details{sales_price}",
				limit: pagination.value.pageSize,
				page: pagination.value.current,
			};
			if (searchString.value)     params.search                  = searchString.value;
			if (filterBrandId.value)    params["filters[brand_id]"]    = filterBrandId.value;
			if (filterCategoryId.value) params["filters[category_id]"] = filterCategoryId.value;

			axiosAdmin.get("products", { params })
				.then(res => {
					products.value = res.data.data || res.data;
					if (res.data.meta) pagination.value.total = res.data.meta.total;
				})
				.finally(() => { loading.value = false; });
		};

		const handleTableChange = pag => {
			pagination.value.current  = pag.current;
			pagination.value.pageSize = pag.pageSize;
			fetchProducts();
		};

		// ── selection ─────────────────────────────────────────────
		const toggleProduct = product => {
			const idx = selectedProducts.value.findIndex(p => p.xid === product.xid);
			if (idx === -1) selectedProducts.value.push(product);
			else            selectedProducts.value.splice(idx, 1);
		};

		const toggleSelectAll = e => {
			if (e.target.checked) {
				products.value.forEach(p => {
					if (!selectedProducts.value.some(s => s.xid === p.xid))
						selectedProducts.value.push(p);
				});
			} else {
				selectedProducts.value = selectedProducts.value.filter(
					s => !products.value.some(p => p.xid === s.xid)
				);
			}
		};

		const addSelectedToQueue = () => {
			selectedProducts.value.forEach(product => {
				if (!printQueue.value.some(q => q.xid === product.xid))
					printQueue.value.push({ ...product, quantity: 1 });
			});
			selectedProducts.value = [];
		};

		const removeFromQueue = xid => {
			printQueue.value = printQueue.value.filter(q => q.xid !== xid);
		};

		// ── print ─────────────────────────────────────────────────
		const printBarcodes = () => {
			const content = document.getElementById("bulkBarcodePrintArea").innerHTML;
			const win     = window.open("", "", "height=800,width=900");
			win.document.write(`<!DOCTYPE html><html><head><title>Bulk Barcode Print</title><style>
				*{margin:0;padding:0;box-sizing:border-box}body{font-family:Arial,sans-serif}
				.bulk-print-page{display:flex;flex-wrap:wrap;padding:10px}
				.barcode-label{display:inline-flex;flex-direction:column;align-items:center;
					justify-content:center;border:1px dashed #ccc;padding:4px;page-break-inside:avoid}
				.label-small{height:80px}.label-medium{height:110px}.label-large{height:140px}
				.label-small svg{height:40px!important}.label-medium svg{height:60px!important}.label-large svg{height:80px!important}
				.label-product-name{font-size:10px;font-weight:700;text-align:center;margin-top:2px;
					max-width:100%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
				.label-price{font-size:10px;color:#333;text-align:center}
				@media print{body{margin:0}.bulk-print-page{padding:5px}}
			</style></head><body>${content}</body></html>`);
			win.document.close();
			win.focus();
			setTimeout(() => { win.print(); win.close(); }, 500);
		};

		onMounted(() => {
			Promise.all([
				axiosAdmin.get("categories?limit=10000"),
				axiosAdmin.get("brands?limit=10000"),
			]).then(([catRes, brandRes]) => {
				categories.value = getRecursiveCategories(catRes);
				brands.value     = brandRes.data;
			});
			fetchProducts();
		});

		return {
			permsArray, formatAmountCurrency, filterTreeNode,
			searchString, filterBrandId, filterCategoryId,
			products, categories, brands, loading, pagination, productColumns,
			selectedProducts, isAllSelected, isIndeterminate,
			toggleProduct, toggleSelectAll,
			printQueue, addSelectedToQueue, removeFromQueue, printBarcodes,
			labelSize, columnsPerRow, showPrice, showProductName,
			barcodeOptions, previewCells, labelSizeLabel,
			fetchProducts, handleTableChange,
		};
	},
};
</script>

<style lang="less" scoped>
.page-content-container { padding: 20px; }
.mb-16  { margin-bottom: 16px; }
.mb-20  { margin-bottom: 20px; }
.mb-10  { margin-bottom: 10px; }

/* ── Live Preview Sheet ──────────────────────────── */
.preview-sheet {
	display: flex;
	flex-wrap: wrap;
	background: #fff;
	border: 1px solid #e0e0e0;
	border-radius: 4px;
	padding: 6px;
	min-height: 80px;
	box-shadow: 0 1px 4px rgba(0,0,0,.08);
}

.preview-label {
	display: inline-flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	border: 1px dashed #bbb;
	padding: 4px 2px;
	box-sizing: border-box;
	background: #fafafa;
	overflow: hidden;

	&.preview-small  { height: 72px; }
	&.preview-medium { height: 96px; }
	&.preview-large  { height: 120px; }
}

/* Mock barcode made with CSS stripes */
.mock-barcode {
	display: flex;
	align-items: flex-end;
	gap: 1px;
	height: 32px;
	margin-bottom: 2px;
}
.bar {
	display: inline-block;
	background: #222;
	width: 2px;
	height: 28px;
	border-radius: 0;
	&.wide { width: 4px; }
	&.gap  { background: transparent; }
}
.mock-code  { font-size: 8px; color: #333; letter-spacing: 1px; }
.mock-name  { font-size: 7px; font-weight: 700; color: #444; margin-top: 2px; white-space: nowrap; overflow: hidden; max-width: 90%; text-overflow: ellipsis; }
.mock-price { font-size: 7px; color: #666; }

.preview-hint {
	text-align: center;
	font-size: 11px;
	color: #888;
	margin-top: 6px;
}

/* ── Print Queue items ───────────────────────────── */
.empty-queue { padding: 20px 0; }

.queue-item {
	.queue-product-name {
		font-size: 13px;
		font-weight: 600;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
	.queue-item-code { font-size: 11px; color: #888; }
}

/* ── Hidden print area ───────────────────────────── */
#bulkBarcodePrintArea {
	.bulk-print-page { display: flex; flex-wrap: wrap; }
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
