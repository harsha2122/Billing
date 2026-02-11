<template>
    <a-drawer
        :title="$t('payments.order_payment')"
        width="80%"
        :maskClosable="false"
        :visible="visible"
        @close="drawerClosed"
    >
        <a-row :gutter="16">
            <!-- Left Column: Payment Info -->
            <a-col :xs="24" :sm="24" :md="10" :lg="10">
                <a-row :gutter="[0, 12]">
                    <a-col :span="12">
                        <a-statistic
                            :title="$t('stock.total_items')"
                            :value="selectedProducts.length"
                        />
                    </a-col>
                    <a-col :span="12">
                        <a-statistic
                            :title="$t('stock.paying_amount')"
                            :value="formatAmountCurrency(totalEnteredAmount)"
                        />
                    </a-col>
                    <a-col :span="12">
                        <a-statistic
                            :title="$t('stock.payable_amount')"
                            :value="formatAmountCurrency(data.subtotal)"
                        />
                    </a-col>
                    <a-col :span="12">
                        <a-statistic
                            v-if="totalEnteredAmount <= data.subtotal"
                            :title="$t('payments.due_amount')"
                            :value="formatAmountCurrency(data.subtotal - totalEnteredAmount)"
                        />
                        <a-statistic
                            v-else
                            :title="$t('stock.change_return')"
                            :value="formatAmountCurrency(totalEnteredAmount - data.subtotal)"
                        />
                    </a-col>
                </a-row>

                <a-divider style="margin: 12px 0" />

                <!-- Payment Add / List -->
                <div v-if="!showAddForm">
                    <a-space style="margin-bottom: 12px">
                        <a-button type="primary" @click="() => (showAddForm = true)">
                            <PlusOutlined />
                            {{ $t("payments.add") }}
                        </a-button>
                    </a-space>
                    <a-table
                        :dataSource="allPaymentRecords"
                        :columns="paymentRecordsColumns"
                        :pagination="false"
                        size="small"
                    >
                        <template #bodyCell="{ column, record }">
                            <template v-if="column.dataIndex === 'payment_mode'">
                                {{ getPaymentModeName(record.payment_mode_id) }}
                            </template>
                            <template v-if="column.dataIndex === 'amount'">
                                {{ formatAmountCurrency(record.amount) }}
                            </template>
                            <template v-if="column.dataIndex === 'action'">
                                <a-button
                                    type="primary"
                                    @click="deletePayment(record.id)"
                                    danger
                                    size="small"
                                >
                                    <template #icon><DeleteOutlined /></template>
                                </a-button>
                            </template>
                        </template>
                    </a-table>
                </div>
                <div v-else>
                    <a-button type="link" @click="goBack" style="padding: 0; margin-bottom: 8px">
                        <LeftOutlined />
                        {{ $t("common.back") }}
                    </a-button>
                    <a-form layout="vertical">
                        <a-row :gutter="16">
                            <a-col :span="12">
                                <a-form-item
                                    :label="$t('payments.payment_mode')"
                                    name="payment_mode_id"
                                    :help="rules.payment_mode_id ? rules.payment_mode_id.message : null"
                                    :validateStatus="rules.payment_mode_id ? 'error' : null"
                                >
                                    <a-select
                                        v-model:value="formData.payment_mode_id"
                                        :placeholder="$t('common.select_default_text', [$t('payments.payment_mode')])"
                                        :allowClear="true"
                                    >
                                        <a-select-option
                                            v-for="paymentMode in paymentModes"
                                            :key="paymentMode.xid"
                                            :value="paymentMode.xid"
                                        >
                                            {{ paymentMode.name }}
                                        </a-select-option>
                                    </a-select>
                                </a-form-item>
                            </a-col>
                            <a-col :span="12">
                                <a-form-item
                                    :label="$t('stock.paying_amount')"
                                    name="amount"
                                    :help="rules.amount ? rules.amount.message : null"
                                    :validateStatus="rules.amount ? 'error' : null"
                                >
                                    <a-input
                                        :prefix="appSetting.currency.symbol"
                                        v-model:value="formData.amount"
                                        :placeholder="$t('common.placeholder_default_text', [$t('stock.payable_amount')])"
                                    />
                                </a-form-item>
                            </a-col>
                        </a-row>
                        <a-form-item
                            :label="$t('payments.notes')"
                            name="notes"
                            :help="rules.notes ? rules.notes.message : null"
                            :validateStatus="rules.notes ? 'error' : null"
                        >
                            <a-textarea
                                v-model:value="formData.notes"
                                :placeholder="$t('payments.notes')"
                                :rows="3"
                            />
                        </a-form-item>
                        <a-button type="primary" :loading="loading" @click="onSubmit" block>
                            <template #icon><CheckOutlined /></template>
                            {{ $t("common.add") }}
                        </a-button>
                    </a-form>
                </div>

                <a-divider style="margin: 16px 0" />

                <!-- Template Selector + Complete Order -->
                <div>
                    <label style="display: block; margin-bottom: 6px; font-weight: 600; font-size: 13px">
                        {{ $t("common.invoice_template") || "Invoice Template" }}
                    </label>
                    <a-select
                        v-model:value="selectedTemplateSlug"
                        style="width: 100%; margin-bottom: 12px"
                        @change="onTemplateChange"
                    >
                        <a-select-option value="default">
                            Default (Thermal)
                        </a-select-option>
                        <a-select-option
                            v-for="tpl in invoiceTemplates"
                            :key="tpl.slug"
                            :value="tpl.slug"
                        >
                            {{ tpl.name }}
                        </a-select-option>
                    </a-select>
                    <a-button
                        type="primary"
                        block
                        :disabled="!hasPreviewedTemplate"
                        @click="completeOrder"
                        size="large"
                    >
                        {{ $t("stock.complete_order") }}
                        <RightOutlined />
                    </a-button>
                    <div v-if="!hasPreviewedTemplate" style="color: #999; font-size: 12px; margin-top: 4px; text-align: center">
                        Select a template to preview before completing
                    </div>
                </div>
            </a-col>

            <!-- Right Column: Invoice Preview -->
            <a-col :xs="24" :sm="24" :md="14" :lg="14">
                <div class="invoice-preview-wrapper">
                    <div class="invoice-preview-header">
                        <strong>Invoice Preview</strong>
                    </div>
                    <div class="invoice-preview-body" :class="selectedTemplateSlug === 'default' ? 'preview-thermal' : 'preview-a4'">
                        <!-- Default Thermal Preview -->
                        <div v-if="selectedTemplateSlug === 'default'" style="max-width: 360px; margin: 0 auto">
                            <div class="preview-thermal-content">
                                <div style="text-align: center; margin-bottom: 8px">
                                    <img
                                        v-if="selectedWarehouse && selectedWarehouse.logo_url"
                                        :src="selectedWarehouse.logo_url"
                                        style="max-width: 60px; max-height: 40px; object-fit: contain"
                                    />
                                    <img
                                        v-else-if="appSetting && appSetting.light_logo_url"
                                        :src="appSetting.light_logo_url"
                                        style="max-width: 60px; max-height: 40px; object-fit: contain"
                                    />
                                    <h3 style="margin: 4px 0 0">{{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</h3>
                                    <p style="font-size: 10px; margin: 0; color: #666">{{ selectedWarehouse ? selectedWarehouse.address : appSetting.address }}</p>
                                </div>
                                <div style="text-align: center; border-top: 1px dashed #ccc; border-bottom: 1px dashed #ccc; padding: 3px 0; margin-bottom: 6px">
                                    <strong style="font-size: 11px">TAX INVOICE</strong>
                                </div>
                                <table style="width: 100%; font-size: 10px; margin-bottom: 6px">
                                    <tr><td>Invoice: PREVIEW</td><td style="text-align: right">Date: {{ formatDate(new Date()) }}</td></tr>
                                </table>
                                <table style="width: 100%; font-size: 10px; border-collapse: collapse">
                                    <thead>
                                        <tr style="background: #f5f5f5">
                                            <td style="padding: 3px; font-weight: 600">#</td>
                                            <td style="padding: 3px; font-weight: 600">Item</td>
                                            <td style="padding: 3px; font-weight: 600">Qty</td>
                                            <td style="padding: 3px; font-weight: 600">Rate</td>
                                            <td style="padding: 3px; font-weight: 600; text-align: right">Total</td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="(item, idx) in selectedProducts" :key="idx" style="border-bottom: 1px dotted #eee">
                                            <td style="padding: 3px">{{ idx + 1 }}</td>
                                            <td style="padding: 3px">{{ item.name }}</td>
                                            <td style="padding: 3px">{{ item.quantity }}{{ item.unit_short_name }}</td>
                                            <td style="padding: 3px">{{ formatAmountCurrency(item.unit_price) }}</td>
                                            <td style="padding: 3px; text-align: right">{{ formatAmountCurrency(item.subtotal) }}</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <div style="border-top: 1px dashed #ccc; margin-top: 4px; padding-top: 4px; font-size: 11px; text-align: right">
                                    <div><strong>Total: {{ formatAmountCurrency(data.subtotal) }}</strong></div>
                                    <div>Paid: {{ formatAmountCurrency(totalEnteredAmount) }}</div>
                                </div>
                            </div>
                        </div>

                        <!-- Dynamic Template Preview -->
                        <div v-else>
                            <component
                                :is="currentPreviewComponent"
                                :order="previewOrder"
                                :appSetting="appSetting"
                                :selectedWarehouse="selectedWarehouse"
                                :formatAmountCurrency="formatAmountCurrency"
                                :formatDate="formatDate"
                                :amountInWords="previewAmountInWords"
                            />
                        </div>
                    </div>
                </div>
            </a-col>
        </a-row>
    </a-drawer>
</template>

<script>
import { ref, onMounted, computed } from "vue";
import {
    CheckOutlined,
    PlusOutlined,
    LeftOutlined,
    RightOutlined,
    DeleteOutlined,
} from "@ant-design/icons-vue";
import { useI18n } from "vue-i18n";
import { find, filter, sumBy } from "lodash-es";
import common from "../../../../common/composable/common";
import apiAdmin from "../../../../common/composable/apiAdmin";
import GstDistributorInvoice from "./templates/GstDistributorInvoice.vue";
import DoubleDivineInvoice from "./templates/DoubleDivineInvoice.vue";
import GstTheme2Invoice from "./templates/GstTheme2Invoice.vue";
import GstTheme1Invoice from "./templates/GstTheme1Invoice.vue";
import LandscapeTheme1Invoice from "./templates/LandscapeTheme1Invoice.vue";
import TallyThemeInvoice from "./templates/TallyThemeInvoice.vue";

const templateComponentMap = {
    "gst-distributor": GstDistributorInvoice,
    "double-divine": DoubleDivineInvoice,
    "gst-theme-2": GstTheme2Invoice,
    "gst-theme-1": GstTheme1Invoice,
    "landscape-theme-1": LandscapeTheme1Invoice,
    "tally-theme": TallyThemeInvoice,
};

function convertNumberToWords(num) {
    if (num === 0) return "Zero Rupees only";
    const ones = ["", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
        "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen",
        "Seventeen", "Eighteen", "Nineteen"];
    const tens = ["", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"];
    num = Math.round(parseFloat(num) * 100) / 100;
    const whole = Math.floor(num);
    const decimal = Math.round((num - whole) * 100);
    function toIndianWords(n) {
        if (n === 0) return "";
        let result = "";
        if (n >= 10000000) { result += toIndianWords(Math.floor(n / 10000000)) + " Crore "; n %= 10000000; }
        if (n >= 100000) { result += toIndianWords(Math.floor(n / 100000)) + " Lakh "; n %= 100000; }
        if (n >= 1000) { result += toIndianWords(Math.floor(n / 1000)) + " Thousand "; n %= 1000; }
        if (n >= 100) { result += ones[Math.floor(n / 100)] + " Hundred "; n %= 100; }
        if (n >= 20) { result += tens[Math.floor(n / 10)] + " "; n %= 10; }
        if (n > 0) { result += ones[n] + " "; }
        return result.trim();
    }
    let words = toIndianWords(whole) + " Rupees";
    if (decimal > 0) { words += " and " + toIndianWords(decimal) + " Paise"; }
    return words + " only";
}

export default {
    props: ["visible", "data", "selectedProducts"],
    emits: ["closed", "success"],
    components: {
        CheckOutlined,
        PlusOutlined,
        LeftOutlined,
        RightOutlined,
        DeleteOutlined,
        GstDistributorInvoice,
        DoubleDivineInvoice,
        GstTheme2Invoice,
        GstTheme1Invoice,
        LandscapeTheme1Invoice,
        TallyThemeInvoice,
    },
    setup(props, { emit }) {
        const { addEditRequestAdmin, loading, rules } = apiAdmin();
        const { appSetting, selectedWarehouse, formatAmountCurrency, formatDate } = common();
        const paymentModes = ref([]);
        const invoiceTemplates = ref([]);
        const selectedTemplateSlug = ref("default");
        const hasPreviewedTemplate = ref(false);
        const formData = ref({
            payment_mode_id: undefined,
            amount: 0,
            notes: "",
        });
        const { t } = useI18n();
        const allPaymentRecords = ref([]);
        const paymentRecordsColumns = ref([
            { title: t("payments.payment_mode"), dataIndex: "payment_mode" },
            { title: t("payments.amount"), dataIndex: "amount" },
            { title: t("common.action"), dataIndex: "action" },
        ]);
        const showAddForm = ref(false);

        onMounted(() => {
            axiosAdmin.get("payment-modes").then((response) => {
                paymentModes.value = response.data;
            });
            axiosAdmin.get("pos-invoice-templates?limit=10000").then((response) => {
                invoiceTemplates.value = response.data;
                const defaultTpl = invoiceTemplates.value.find((t) => t.is_default);
                if (defaultTpl) {
                    selectedTemplateSlug.value = defaultTpl.slug;
                }
                hasPreviewedTemplate.value = true;
            }).catch(() => {});
        });

        const currentPreviewComponent = computed(() => {
            return templateComponentMap[selectedTemplateSlug.value] || null;
        });

        const previewOrder = computed(() => {
            const items = (props.selectedProducts || []).map((p, i) => ({
                product: { name: p.name, hsn_sac_code: p.hsn_sac_code || "" },
                quantity: p.quantity,
                unit: { short_name: p.unit_short_name || "" },
                single_unit_price: p.single_unit_price || p.unit_price,
                unit_price: p.unit_price,
                subtotal: p.subtotal,
                total_tax: p.total_tax || 0,
                tax_type: p.tax_type || "exclusive",
                hsn_sac_code: p.hsn_sac_code || "",
            }));

            const paidAmount = sumBy(allPaymentRecords.value, (r) => parseFloat(r.amount || 0));
            const total = props.data ? props.data.subtotal : 0;

            return {
                xid: "preview",
                invoice_number: "PREVIEW",
                order_date: new Date().toISOString(),
                items: items,
                subtotal: total,
                total: total,
                tax_amount: props.data ? props.data.tax_amount : 0,
                tax_rate: props.data ? props.data.tax_rate : 0,
                discount: props.data ? props.data.discount : 0,
                shipping: props.data ? props.data.shipping : 0,
                paid_amount: paidAmount,
                due_amount: Math.max(0, total - paidAmount),
                total_items: items.length,
                total_quantity: items.reduce((sum, i) => sum + (i.quantity || 0), 0),
                user: { name: "Customer", phone: "" },
                staff_member: { name: "Staff" },
                order_payments: allPaymentRecords.value.map((r) => ({
                    amount: r.amount,
                    payment: {
                        payment_mode: {
                            name: getPaymentModeNameRaw(r.payment_mode_id),
                        },
                    },
                })),
            };
        });

        const previewAmountInWords = computed(() => {
            const total = props.data ? props.data.subtotal : 0;
            if (!total) return "";
            return convertNumberToWords(total);
        });

        const onTemplateChange = () => {
            hasPreviewedTemplate.value = true;
        };

        const getPaymentModeNameRaw = (paymentId) => {
            var selectedMode = find(paymentModes.value, ["xid", paymentId]);
            return selectedMode ? selectedMode.name : "-";
        };

        const drawerClosed = () => {
            formData.value = { payment_mode_id: undefined, amount: 0, notes: "" };
            allPaymentRecords.value = [];
            emit("closed");
        };

        const onSubmit = () => {
            addEditRequestAdmin({
                url: "pos/payment",
                data: formData.value,
                success: (res) => {
                    allPaymentRecords.value = [
                        ...allPaymentRecords.value,
                        { ...formData.value, id: Math.random().toString(36).slice(2) },
                    ];
                    formData.value = { payment_mode_id: undefined, amount: 0, notes: "" };
                    showAddForm.value = false;
                },
            });
        };

        const completeOrder = () => {
            const selectedTpl = find(invoiceTemplates.value, ["slug", selectedTemplateSlug.value]);

            const newFormDataObject = {
                all_payments: allPaymentRecords.value,
                product_items: props.selectedProducts,
                details: {
                    ...props.data,
                    pos_invoice_template_id: selectedTpl ? selectedTpl.xid : undefined,
                },
            };

            addEditRequestAdmin({
                url: "pos/save",
                data: newFormDataObject,
                successMessage: props.successMessage,
                success: (res) => {
                    formData.value = { payment_mode_id: undefined, amount: 0, notes: "" };
                    allPaymentRecords.value = [];
                    showAddForm.value = false;
                    hasPreviewedTemplate.value = false;
                    emit("success", res.order, selectedTemplateSlug.value);
                },
            });
        };

        const goBack = () => {
            formData.value = { payment_mode_id: undefined, amount: 0, notes: "" };
            showAddForm.value = false;
        };

        const getPaymentModeName = (paymentId) => {
            return getPaymentModeNameRaw(paymentId);
        };

        const deletePayment = (paymentId) => {
            allPaymentRecords.value = filter(allPaymentRecords.value, (r) => r.id != paymentId);
        };

        const totalEnteredAmount = computed(() => {
            var allPaymentSum = sumBy(allPaymentRecords.value, (r) => parseFloat(r.amount));
            return allPaymentSum + parseFloat(formData.value.amount);
        });

        return {
            loading,
            rules,
            drawerClosed,
            paymentModes,
            invoiceTemplates,
            selectedTemplateSlug,
            hasPreviewedTemplate,
            formData,
            appSetting,
            selectedWarehouse,
            formatAmountCurrency,
            formatDate,
            onSubmit,
            allPaymentRecords,
            paymentRecordsColumns,
            showAddForm,
            completeOrder,
            goBack,
            getPaymentModeName,
            deletePayment,
            totalEnteredAmount,
            currentPreviewComponent,
            previewOrder,
            previewAmountInWords,
            onTemplateChange,
        };
    },
};
</script>

<style scoped>
.invoice-preview-wrapper {
    border: 1px solid #e8e8e8;
    border-radius: 6px;
    background: #fafafa;
    height: 100%;
    display: flex;
    flex-direction: column;
}
.invoice-preview-header {
    padding: 8px 16px;
    background: #f0f0f0;
    border-bottom: 1px solid #e8e8e8;
    border-radius: 6px 6px 0 0;
    font-size: 13px;
}
.invoice-preview-body {
    padding: 16px;
    overflow-y: auto;
    max-height: calc(100vh - 180px);
    background: #fff;
    border-radius: 0 0 6px 6px;
}
.preview-a4 {
    padding: 20px;
}
.preview-thermal {
    padding: 12px;
}
</style>
