<template>
    <a-modal
        :visible="visible"
        :centered="true"
        :maskClosable="false"
        :title="$t('common.print_invoice')"
        :width="modalWidth"
        @cancel="onClose"
    >
        <div id="pos-invoice" :class="printSizeClass">
            <!-- Default Thermal Template -->
            <div v-if="activeSlug === 'default'" style="max-width: 400px; margin: 0px auto" >
                <div v-if="order && order.xid">
                    <div class="invoice-header">
                        <img
                            v-if="selectedWarehouse && selectedWarehouse.logo_url"
                            class="invoice-logo"
                            :src="selectedWarehouse.logo_url"
                            :alt="selectedWarehouse.name"
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

            <!-- Dynamic Template (A4 size) -->
            <div v-else style="margin: 0px auto">
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
import { defineComponent, computed } from "vue";
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
    props: ["visible", "order", "selectedTemplateSlug"],
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

        const activeSlug = computed(() => {
            return props.selectedTemplateSlug || "default";
        });

        const isThermal = computed(() => {
            return activeSlug.value === "default";
        });

        const currentTemplateComponent = computed(() => {
            return templateComponentMap[activeSlug.value] || null;
        });

        const modalWidth = computed(() => {
            if (activeSlug.value === "landscape-theme-1") {
                return "900px";
            }
            if (isThermal.value) {
                return "450px";
            }
            return "850px";
        });

        const printSizeClass = computed(() => {
            return isThermal.value ? "print-thermal" : "print-a4";
        });

        const amountInWords = computed(() => {
            if (!props.order || !props.order.total) return "";
            return convertNumberToWords(props.order.total);
        });

        const onClose = () => {
            emit("closed");
        };

        const printInvoice = () => {
            var invoiceContent = document.getElementById("pos-invoice").innerHTML;
            var printClass = isThermal.value ? "print-thermal" : "print-a4";
            var windowWidth = isThermal.value ? 400 : 900;
            var windowHeight = isThermal.value ? 600 : 1000;

            // Collect all stylesheets and inline styles from the current page
            var allStyles = "";
            // 1. Link the pos_invoice_css
            allStyles += '<link rel="stylesheet" href="' + posInvoiceCssUrl + '">';
            // 2. Copy all <style> tags (includes Vue scoped component styles)
            var styleTags = document.querySelectorAll("style");
            for (var i = 0; i < styleTags.length; i++) {
                allStyles += "<style>" + styleTags[i].innerHTML + "</style>";
            }
            // 3. Copy linked stylesheets (app.css, antd.css, etc.)
            var linkTags = document.querySelectorAll('link[rel="stylesheet"]');
            for (var j = 0; j < linkTags.length; j++) {
                allStyles += '<link rel="stylesheet" href="' + linkTags[j].href + '">';
            }

            var newWindow = window.open("", "", "height=" + windowHeight + ", width=" + windowWidth);
            newWindow.document.write(
                "<html><head>" + allStyles + "</head><body class=\"" + printClass + "\">"
            );
            newWindow.document.write(invoiceContent);
            newWindow.document.write("</body></html>");
            newWindow.document.close();
            // Wait for stylesheets to load before printing
            newWindow.onload = function() {
                newWindow.print();
            };
        };

        return {
            appSetting,
            selectedWarehouse,
            onClose,
            formatDate,
            formatAmountCurrency,
            printInvoice,
            activeSlug,
            isThermal,
            currentTemplateComponent,
            modalWidth,
            printSizeClass,
            amountInWords,
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
