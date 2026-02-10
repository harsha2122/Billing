<template>
    <div class="double-divine-invoice">
        <!-- Red Header Bar -->
        <div class="header-bar">
            <div class="header-bar-content">
                <h2 class="header-company-name">
                    {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}
                </h2>
                <span class="header-phone" v-if="(selectedWarehouse && selectedWarehouse.phone) || (appSetting && appSetting.phone)">
                    {{ selectedWarehouse ? selectedWarehouse.phone : appSetting.phone }}
                </span>
            </div>
        </div>

        <!-- Company Details -->
        <div class="company-details">
            <div class="company-logo-wrap" v-if="(selectedWarehouse && selectedWarehouse.logo_url) || (appSetting && appSetting.light_logo_url)">
                <img
                    :src="selectedWarehouse && selectedWarehouse.logo_url ? selectedWarehouse.logo_url : appSetting.light_logo_url"
                    :alt="selectedWarehouse ? selectedWarehouse.name : appSetting.name"
                    class="company-logo"
                />
            </div>
            <p class="company-address">
                {{ selectedWarehouse ? selectedWarehouse.address : appSetting.address }}
            </p>
            <p v-if="(selectedWarehouse && selectedWarehouse.email) || (appSetting && appSetting.email)">
                Email: {{ selectedWarehouse ? selectedWarehouse.email : appSetting.email }}
            </p>
            <p v-if="selectedWarehouse && selectedWarehouse.gstin">
                GSTIN: {{ selectedWarehouse.gstin }}
            </p>
        </div>

        <!-- Tax Invoice Title -->
        <div class="invoice-title-section">
            <h3 class="invoice-title">Tax Invoice</h3>
            <div class="title-underline"></div>
        </div>

        <!-- Invoice Info Row -->
        <div class="invoice-info-row">
            <table class="info-table">
                <tr>
                    <td><strong>Invoice #:</strong> {{ order.invoice_number }}</td>
                    <td class="text-right"><strong>Date:</strong> {{ formatDate(order.order_date) }}</td>
                </tr>
                <tr>
                    <td><strong>Customer:</strong> {{ order.user ? order.user.name : '' }}</td>
                    <td class="text-right">
                        <span v-if="order.staff_member"><strong>Sold By:</strong> {{ order.staff_member.name }}</span>
                    </td>
                </tr>
                <tr v-if="order.user && order.user.phone">
                    <td><strong>Phone:</strong> {{ order.user.phone }}</td>
                    <td class="text-right">
                        <span v-if="order.user && order.user.tax_number">
                            <strong>GSTIN:</strong> {{ order.user.tax_number }}
                        </span>
                    </td>
                </tr>
            </table>
        </div>

        <!-- Items Table -->
        <table class="items-table">
            <thead>
                <tr>
                    <th class="col-sn">#</th>
                    <th class="col-item">Item</th>
                    <th class="col-hsn">HSN/SAC</th>
                    <th class="col-qty">Qty</th>
                    <th class="col-rate">Rate</th>
                    <th class="col-amount">Amount</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(item, index) in order.items" :key="index">
                    <td>{{ index + 1 }}</td>
                    <td>{{ item.product ? item.product.name : '' }}</td>
                    <td>{{ item.hsn_sac_code || (item.product ? item.product.hsn_sac_code : '') }}</td>
                    <td>{{ item.quantity }}{{ item.unit ? item.unit.short_name : '' }}</td>
                    <td>{{ formatAmountCurrency(item.single_unit_price) }}</td>
                    <td class="text-right">{{ formatAmountCurrency(item.subtotal) }}</td>
                </tr>
            </tbody>
            <tfoot>
                <tr class="subtotal-row">
                    <td colspan="4"></td>
                    <td><strong>Subtotal</strong></td>
                    <td class="text-right">{{ formatAmountCurrency(order.subtotal) }}</td>
                </tr>
                <tr v-if="order.tax_amount" class="tax-row">
                    <td colspan="4"></td>
                    <td>Tax</td>
                    <td class="text-right">{{ formatAmountCurrency(order.tax_amount) }}</td>
                </tr>
                <tr v-if="order.discount" class="discount-row">
                    <td colspan="4"></td>
                    <td>Discount</td>
                    <td class="text-right">- {{ formatAmountCurrency(order.discount) }}</td>
                </tr>
                <tr v-if="order.shipping" class="shipping-row">
                    <td colspan="4"></td>
                    <td>Shipping</td>
                    <td class="text-right">{{ formatAmountCurrency(order.shipping) }}</td>
                </tr>
            </tfoot>
        </table>

        <!-- Amount in Words -->
        <div class="amount-words-section" v-if="amountInWords">
            <strong>Amount in Words:</strong> {{ amountInWords }}
        </div>

        <!-- Totals Box -->
        <div class="totals-box">
            <table class="totals-table">
                <tr class="total-row">
                    <td><strong>Total</strong></td>
                    <td class="text-right"><strong>{{ formatAmountCurrency(order.total) }}</strong></td>
                </tr>
                <tr class="received-row">
                    <td>Received</td>
                    <td class="text-right">{{ formatAmountCurrency(order.paid_amount) }}</td>
                </tr>
                <tr class="balance-row" v-if="order.due_amount">
                    <td><strong>Balance</strong></td>
                    <td class="text-right"><strong>{{ formatAmountCurrency(order.due_amount) }}</strong></td>
                </tr>
            </table>
        </div>

        <!-- Payment Mode -->
        <div class="payment-info" v-if="order.order_payments && order.order_payments.length > 0">
            <strong>Payment:</strong>
            <span v-for="(payment, pIndex) in order.order_payments" :key="'pay-' + pIndex">
                {{ formatAmountCurrency(payment.amount) }}
                <span v-if="payment.payment && payment.payment.payment_mode">
                    ({{ payment.payment.payment_mode.name }})
                </span>
                <span v-if="pIndex < order.order_payments.length - 1">, </span>
            </span>
        </div>

        <!-- Terms & Conditions -->
        <div class="terms-section" v-if="order.terms_condition || (selectedWarehouse && selectedWarehouse.terms_condition)">
            <strong>Terms & Conditions:</strong>
            <p>{{ order.terms_condition || (selectedWarehouse ? selectedWarehouse.terms_condition : '') }}</p>
        </div>

        <!-- Authorized Signatory -->
        <div class="signatory-section">
            <div class="signatory-block">
                <p class="for-company">For {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</p>
                <img
                    v-if="selectedWarehouse && selectedWarehouse.signature_url"
                    :src="selectedWarehouse.signature_url"
                    alt="Signature"
                    class="signature-img"
                />
                <div class="signatory-line"></div>
                <p>Authorized Signatory</p>
            </div>
        </div>

        <!-- Footer Bar -->
        <div class="footer-bar">
            <p>Thank you for your business!</p>
        </div>
    </div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
    name: "DoubleDivineInvoice",
    props: [
        "order",
        "appSetting",
        "selectedWarehouse",
        "formatAmountCurrency",
        "formatDate",
        "amountInWords",
    ],
});
</script>

<style scoped>
.double-divine-invoice {
    max-width: 400px;
    margin: 0 auto;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11px;
    color: #333;
    line-height: 1.4;
}

.header-bar {
    background: #c0392b;
    color: #fff;
    padding: 8px 10px;
    margin-bottom: 6px;
}

.header-bar-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.header-company-name {
    margin: 0;
    font-size: 15px;
    font-weight: bold;
    color: #fff;
}

.header-phone {
    font-size: 11px;
    color: #fff;
}

.company-details {
    text-align: center;
    padding: 4px 0;
    margin-bottom: 4px;
}

.company-details p {
    margin: 1px 0;
    font-size: 10px;
}

.company-logo-wrap {
    margin-bottom: 4px;
}

.company-logo {
    max-width: 80px;
    max-height: 45px;
    object-fit: contain;
}

.company-address {
    font-size: 10px;
}

.invoice-title-section {
    text-align: center;
    margin-bottom: 6px;
}

.invoice-title {
    margin: 0;
    font-size: 14px;
    color: #c0392b;
    text-transform: uppercase;
    font-weight: bold;
}

.title-underline {
    width: 80px;
    height: 2px;
    background: #c0392b;
    margin: 2px auto 0;
}

.info-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 6px;
}

.info-table td {
    padding: 2px 4px;
    font-size: 10px;
    border-bottom: 1px dotted #ddd;
}

.text-right {
    text-align: right;
}

.items-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 6px;
}

.items-table thead tr {
    background: #c0392b;
    color: #fff;
}

.items-table th {
    padding: 4px 3px;
    font-size: 9px;
    text-align: left;
    border: 1px solid #c0392b;
}

.items-table td {
    padding: 3px;
    font-size: 10px;
    border: 1px solid #eee;
    border-bottom: 1px solid #ddd;
}

.items-table tfoot td {
    border: none;
    border-top: 1px solid #eee;
    padding: 2px 3px;
    font-size: 10px;
}

.col-sn { width: 5%; }
.col-item { width: 30%; }
.col-hsn { width: 15%; }
.col-qty { width: 12%; }
.col-rate { width: 18%; }
.col-amount { width: 20%; text-align: right; }

.amount-words-section {
    background: #fdf2f0;
    border-left: 3px solid #c0392b;
    padding: 4px 6px;
    margin-bottom: 6px;
    font-size: 10px;
}

.totals-box {
    border: 2px solid #c0392b;
    padding: 4px 6px;
    margin-bottom: 6px;
}

.totals-table {
    width: 100%;
    border-collapse: collapse;
}

.totals-table td {
    padding: 3px 4px;
    font-size: 11px;
}

.total-row td {
    font-size: 13px;
    border-bottom: 1px solid #eee;
    color: #c0392b;
}

.received-row td {
    border-bottom: 1px solid #eee;
}

.balance-row td {
    color: #c0392b;
}

.payment-info {
    font-size: 10px;
    padding: 3px 0;
    margin-bottom: 4px;
    border-bottom: 1px dashed #ddd;
}

.terms-section {
    margin-bottom: 8px;
    font-size: 9px;
    border-top: 1px dashed #ddd;
    padding-top: 4px;
}

.terms-section p {
    margin: 2px 0 0 0;
}

.signatory-section {
    text-align: right;
    margin-top: 12px;
}

.signatory-block {
    display: inline-block;
    text-align: center;
}

.signatory-block p {
    margin: 2px 0;
    font-size: 10px;
}

.for-company {
    font-weight: bold;
}

.signature-img {
    max-width: 100px;
    max-height: 40px;
    object-fit: contain;
    display: block;
    margin: 4px auto;
}

.signatory-line {
    width: 120px;
    border-top: 1px solid #333;
    margin: 4px auto;
}

.footer-bar {
    background: #c0392b;
    color: #fff;
    text-align: center;
    padding: 4px 0;
    margin-top: 8px;
}

.footer-bar p {
    margin: 0;
    font-size: 10px;
}
</style>
