<template>
    <a-modal
        :visible="visible"
        :centered="true"
        :maskClosable="false"
        :title="$t('common.print_invoice')"
        :width="modalWidth"
        @cancel="onClose"
    >
        <div style="margin-bottom: 10px">
            <a-select
                v-model:value="selectedTemplateSlug"
                style="width: 250px"
                :placeholder="$t('common.select_default_text', ['Template'])"
                @change="onTemplateChange"
            >
                <a-select-option value="default">
                    Default (Thermal)
                </a-select-option>
                <a-select-option
                    v-for="tpl in templates"
                    :key="tpl.slug"
                    :value="tpl.slug"
                >
                    {{ tpl.name }}
                </a-select-option>
            </a-select>
        </div>

        <div id="pos-invoice">
            <!-- Default Thermal Template -->
            <div v-if="selectedTemplateSlug === 'default'" style="max-width: 400px; margin: 0px auto" >
                <div v-if="order && order.xid">
                    <div class="invoice-header">
                        <img
                            class="invoice-logo"
                            :src="selectedWarehouse && selectedWarehouse.logo_url ? selectedWarehouse.logo_url : appSetting.light_logo_url"
                            :alt="selectedWarehouse ? selectedWarehouse.name : appSetting.name"
                        />
                    </div>
                    <div class="company-details">
                        <h2>{{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</h2>
                        <p class="company-address">
                            {{ selectedWarehouse ? selectedWarehouse.address : appSetting.address }}
                        </p>
                        <h4 style="margin-bottom: 0px">
                            {{ $t("common.phone") }}: {{ selectedWarehouse ? selectedWarehouse.phone : appSetting.phone }}
                        </h4>
                        <h4>{{ $t("common.email") }}: {{ selectedWarehouse ? selectedWarehouse.email : appSetting.email }}</h4>
                    </div>
                    <div class="tax-invoice-details">
                        <h3 class="tax-invoice-title">{{ $t("sales.tax_invoice") }}</h3>
                        <table class="invoice-customer-details">
                            <tr>
                                <td style="width: 50%">
                                    {{ $t("sales.invoice") }} &nbsp;&nbsp;&nbsp;&nbsp;:
                                    {{ order.invoice_number }}
                                </td>
                                <td style="width: 50%">
                                    {{ $t("common.date") }} :
                                    {{ formatDate(order.order_date) }}
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 50%">
                                    {{ $t("stock.customer") }} : {{ order.user ? order.user.name : '' }}
                                </td>
                                <td style="width: 50%">
                                    {{ $t("stock.sold_by") }} : {{ order.staff_member ? order.staff_member.name : '' }}
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="tax-invoice-items">
                        <table style="width: 100%">
                            <thead style="background: #eee">
                                <td style="width: 5%">#</td>
                                <td style="width: 25%">{{ $t("common.item") }}</td>
                                <td style="width: 20%">{{ $t("common.qty") }}</td>
                                <td style="width: 25%">{{ $t("common.rate") }}</td>
                                <td style="width: 25%; text-align: right">
                                    {{ $t("common.total") }}
                                </td>
                            </thead>
                            <tbody>
                                <tr
                                    class="item-row"
                                    v-for="(item, index) in order.items"
                                    :key="item.xid"
                                >
                                    <td>{{ index + 1 }}</td>
                                    <td>{{ item.product.name }}</td>
                                    <td>{{ item.quantity + "" + item.unit.short_name }}</td>
                                    <td>{{ formatAmountCurrency(item.unit_price) }}</td>
                                    <td style="text-align: right">
                                        {{ formatAmountCurrency(item.subtotal) }}
                                    </td>
                                </tr>
                                <tr class="item-row-other">
                                    <td colspan="3" style="text-align: right">
                                        {{ $t("stock.order_tax") }}
                                    </td>
                                    <td colspan="2" style="text-align: right">
                                        {{ formatAmountCurrency(order.tax_amount) }}
                                    </td>
                                </tr>
                                <tr class="item-row-other">
                                    <td colspan="3" style="text-align: right">
                                        {{ $t("stock.discount") }}
                                    </td>
                                    <td colspan="2" style="text-align: right">
                                        {{ formatAmountCurrency(order.discount) }}
                                    </td>
                                </tr>
                                <tr class="item-row-other">
                                    <td colspan="3" style="text-align: right">
                                        {{ $t("stock.shipping") }}
                                    </td>
                                    <td colspan="2" style="text-align: right">
                                        {{ formatAmountCurrency(order.shipping) }}
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="tax-invoice-totals">
                        <table style="width: 100%">
                            <tr>
                                <td style="width: 30%">
                                    <h3 style="margin-bottom: 0px">
                                        {{ $t("common.items") }}: {{ order.total_items }}
                                    </h3>
                                </td>
                                <td style="width: 30%">
                                    <h3 style="margin-bottom: 0px">
                                        {{ $t("common.qty") }}: {{ order.total_quantity }}
                                    </h3>
                                </td>
                                <td style="width: 40%; text-align: center">
                                    <h3 style="margin-bottom: 0px">
                                        {{ $t("common.total") }}:
                                        {{ formatAmountCurrency(order.total) }}
                                    </h3>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div v-if="amountInWords" style="text-align: center; margin-top: 5px; font-style: italic; border-bottom: 1px dotted #ddd; padding-bottom: 5px;">
                        {{ amountInWords }}
                    </div>
                    <div class="paid-amount-deatils">
                        <table style="width: 100%">
                            <thead style="background: #eee">
                                <td style="width: 50%">{{ $t("payments.paid_amount") }}</td>
                                <td style="width: 50%">{{ $t("payments.due_amount") }}</td>
                            </thead>
                            <tbody>
                                <tr class="paid-amount-row">
                                    <td>{{ formatAmountCurrency(order.paid_amount) }}</td>
                                    <td>{{ formatAmountCurrency(order.due_amount) }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div>
                        <table style="width: 100%">
                            <tr style="text-align: center">
                                <td style="width: 100%">
                                    <h4
                                        style="margin-bottom: 0px"
                                        v-if="order.order_payments"
                                    >
                                        {{ $t("invoice.payment_mode") }}:
                                        <span
                                            v-for="currentOrderPayments in order.order_payments"
                                            :key="currentOrderPayments.xid"
                                            style="margin-right: 5px"
                                        >
                                            {{
                                                formatAmountCurrency(
                                                    currentOrderPayments.amount
                                                )
                                            }}
                                            (<span
                                                v-if="
                                                    currentOrderPayments.payment &&
                                                    currentOrderPayments.payment
                                                        .payment_mode &&
                                                    currentOrderPayments.payment.payment_mode
                                                        .name
                                                "
                                            >
                                                {{
                                                    currentOrderPayments.payment.payment_mode
                                                        .name
                                                }}
                                            </span>
                                            )
                                        </span>
                                    </h4>
                                    <h3 style="margin-bottom: 0px" v-else>
                                        {{ $t("invoice.payment_mode") }}: -
                                    </h3>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="barcode-details">
                        <vue-barcode
                            :value="order.invoice_number"
                            :options="{ height: 25, width: 1, fontSize: 15 }"
                            tag="svg"
                        ></vue-barcode>
                    </div>
                    <div class="thanks-details">
                        <h3>{{ $t("invoice.thanks_message") }}</h3>
                    </div>
                </div>
            </div>

            <!-- Dynamic Template -->
            <div v-else style="max-width: 400px; margin: 0px auto">
                <component
                    v-if="order && order.xid"
                    :is="currentTemplateComponent"
                    :order="order"
                    :appSetting="appSetting"
                    :selectedWarehouse="selectedWarehouse"
                    :formatAmountCurrency="formatAmountCurrency"
                    :formatDate="formatDate"
                    :amountInWords="amountInWords"
                />
            </div>
        </div>

        <template #footer>
            <div class="footer-button">
                <a-button type="primary" @click="printInvoice">
                    <template #icon>
                        <PrinterOutlined />
                    </template>
                    {{ $t("common.print_invoice") }}
                </a-button>
            </div>
        </template>
    </a-modal>
</template>

<script>
import { ref, defineComponent, computed, onMounted, watch } from "vue";
import { PrinterOutlined } from "@ant-design/icons-vue";
import common from "../../../../common/composable/common";
import GstDistributorInvoice from "./templates/GstDistributorInvoice.vue";
import DoubleDivineInvoice from "./templates/DoubleDivineInvoice.vue";
import GstTheme2Invoice from "./templates/GstTheme2Invoice.vue";
import GstTheme1Invoice from "./templates/GstTheme1Invoice.vue";
import LandscapeTheme1Invoice from "./templates/LandscapeTheme1Invoice.vue";
import TallyThemeInvoice from "./templates/TallyThemeInvoice.vue";

const posInvoiceCssUrl = window.config.pos_invoice_css;

const templateComponentMap = {
    "gst-distributor": GstDistributorInvoice,
    "double-divine": DoubleDivineInvoice,
    "gst-theme-2": GstTheme2Invoice,
    "gst-theme-1": GstTheme1Invoice,
    "landscape-theme-1": LandscapeTheme1Invoice,
    "tally-theme": TallyThemeInvoice,
};

export default defineComponent({
    props: ["visible", "order"],
    emits: ["closed", "success"],
    components: {
        PrinterOutlined,
        GstDistributorInvoice,
        DoubleDivineInvoice,
        GstTheme2Invoice,
        GstTheme1Invoice,
        LandscapeTheme1Invoice,
        TallyThemeInvoice,
    },
    setup(props, { emit }) {
        const { appSetting, selectedWarehouse, formatAmountCurrency, formatDate } = common();
        const selectedTemplateSlug = ref("default");
        const templates = ref([]);

        onMounted(() => {
            axiosAdmin.get("pos-invoice-templates?limit=10000").then((response) => {
                templates.value = response.data;

                // Auto-select default template if one exists
                const defaultTpl = templates.value.find((t) => t.is_default);
                if (defaultTpl) {
                    selectedTemplateSlug.value = defaultTpl.slug;
                }
            }).catch(() => {
                // Templates not available yet (migration not run)
            });
        });

        const currentTemplateComponent = computed(() => {
            return templateComponentMap[selectedTemplateSlug.value] || null;
        });

        const modalWidth = computed(() => {
            if (selectedTemplateSlug.value === "landscape-theme-1") {
                return "700px";
            }
            return "450px";
        });

        const amountInWords = computed(() => {
            if (!props.order || !props.order.total) return "";
            return convertNumberToWords(props.order.total);
        });

        const onTemplateChange = () => {
            // Template changed - component re-renders automatically
        };

        const onClose = () => {
            emit("closed");
        };

        const printInvoice = () => {
            var invoiceContent = document.getElementById("pos-invoice").innerHTML;
            var newWindow = window.open("", "", "height=500, width=500");
            newWindow.document.write(
                `<link rel="stylesheet" href="${posInvoiceCssUrl}"><html><body>`
            );
            newWindow.document.write(invoiceContent);
            newWindow.document.write("</body></html>");
            newWindow.document.close();
            newWindow.print();
        };

        return {
            appSetting,
            selectedWarehouse,
            onClose,
            formatDate,
            formatAmountCurrency,
            printInvoice,
            selectedTemplateSlug,
            templates,
            currentTemplateComponent,
            modalWidth,
            amountInWords,
            onTemplateChange,
        };
    },
});

// Client-side number to words (Indian numbering system)
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
        if (n >= 10000000) {
            result += toIndianWords(Math.floor(n / 10000000)) + " Crore ";
            n %= 10000000;
        }
        if (n >= 100000) {
            result += toIndianWords(Math.floor(n / 100000)) + " Lakh ";
            n %= 100000;
        }
        if (n >= 1000) {
            result += toIndianWords(Math.floor(n / 1000)) + " Thousand ";
            n %= 1000;
        }
        if (n >= 100) {
            result += ones[Math.floor(n / 100)] + " Hundred ";
            n %= 100;
        }
        if (n >= 20) {
            result += tens[Math.floor(n / 10)] + " ";
            n %= 10;
        }
        if (n > 0) {
            result += ones[n] + " ";
        }
        return result.trim();
    }

    let words = toIndianWords(whole) + " Rupees";
    if (decimal > 0) {
        words += " and " + toIndianWords(decimal) + " Paise";
    }
    return words + " only";
}
</script>
