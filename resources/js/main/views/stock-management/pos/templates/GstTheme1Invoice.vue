<template>
    <div class="gst-theme1-invoice">
        <!-- Top Header Row -->
        <div class="header-row">
            <div class="header-company-box">
                <h2 class="company-name">
                    {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}
                </h2>
                <p>{{ selectedWarehouse ? selectedWarehouse.address : appSetting.address }}</p>
                <p v-if="(selectedWarehouse && selectedWarehouse.phone) || (appSetting && appSetting.phone)">
                    Phone: {{ selectedWarehouse ? selectedWarehouse.phone : appSetting.phone }}
                </p>
                <p v-if="(selectedWarehouse && selectedWarehouse.email) || (appSetting && appSetting.email)">
                    Email: {{ selectedWarehouse ? selectedWarehouse.email : appSetting.email }}
                </p>
                <p v-if="selectedWarehouse && selectedWarehouse.gstin">
                    GSTIN: {{ selectedWarehouse.gstin }}
                </p>
                <p v-if="selectedWarehouse && selectedWarehouse.state">
                    State: {{ selectedWarehouse.state }}
                    <span v-if="selectedWarehouse.state_code">({{ selectedWarehouse.state_code }})</span>
                </p>
            </div>
            <div class="header-logo-box">
                <img
                    v-if="selectedWarehouse && selectedWarehouse.logo_url"
                    :src="selectedWarehouse.logo_url"
                    :alt="selectedWarehouse.name"
                    class="company-logo"
                />
                <img
                    v-else-if="appSetting && appSetting.light_logo_url"
                    :src="appSetting.light_logo_url"
                    :alt="appSetting.name"
                    class="company-logo"
                />
            </div>
        </div>

        <!-- Tax Invoice Title -->
        <div class="invoice-title-bar">
            <h3>Tax Invoice</h3>
        </div>

        <!-- Invoice Info -->
        <table class="info-table">
            <tr>
                <td><strong>Invoice #:</strong> {{ order.invoice_number }}</td>
                <td class="text-right"><strong>Date:</strong> {{ formatDate(order.order_date) }}</td>
            </tr>
            <tr>
                <td>
                    <strong>Customer:</strong> {{ order.user ? order.user.name : '' }}
                    <span v-if="order.user && order.user.phone"> | {{ order.user.phone }}</span>
                </td>
                <td class="text-right">
                    <span v-if="order.staff_member"><strong>Sold By:</strong> {{ order.staff_member.name }}</span>
                </td>
            </tr>
            <tr v-if="order.user && order.user.tax_number">
                <td colspan="2"><strong>Customer GSTIN:</strong> {{ order.user.tax_number }}</td>
            </tr>
        </table>

        <!-- Items Table -->
        <table class="items-table">
            <thead>
                <tr>
                    <th class="col-sn">#</th>
                    <th class="col-item">Item</th>
                    <th class="col-hsn">HSN/SAC</th>
                    <th class="col-qty">Qty</th>
                    <th class="col-rate">Rate</th>
                    <th class="col-tax">Tax</th>
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
                    <td>
                        <span v-if="item.total_tax">{{ formatAmountCurrency(item.total_tax) }}</span>
                        <span v-else>-</span>
                    </td>
                    <td class="text-right">{{ formatAmountCurrency(item.subtotal) }}</td>
                </tr>
            </tbody>
        </table>

        <!-- Amount in Words -->
        <div class="amount-words" v-if="amountInWords">
            <strong>Amount in Words:</strong> {{ amountInWords }}
        </div>

        <!-- Totals Section -->
        <div class="totals-section">
            <table class="totals-table">
                <tr>
                    <td class="label-cell">Subtotal</td>
                    <td class="value-cell">{{ formatAmountCurrency(order.subtotal) }}</td>
                </tr>
                <tr v-if="order.tax_amount">
                    <td class="label-cell">Tax ({{ order.tax_rate }}%)</td>
                    <td class="value-cell">{{ formatAmountCurrency(order.tax_amount) }}</td>
                </tr>
                <tr v-if="order.discount">
                    <td class="label-cell">Discount</td>
                    <td class="value-cell">- {{ formatAmountCurrency(order.discount) }}</td>
                </tr>
                <tr v-if="order.shipping">
                    <td class="label-cell">Shipping</td>
                    <td class="value-cell">{{ formatAmountCurrency(order.shipping) }}</td>
                </tr>
                <tr class="grand-total-row">
                    <td class="label-cell"><strong>Grand Total</strong></td>
                    <td class="value-cell"><strong>{{ formatAmountCurrency(order.total) }}</strong></td>
                </tr>
                <tr>
                    <td class="label-cell">Paid</td>
                    <td class="value-cell">{{ formatAmountCurrency(order.paid_amount) }}</td>
                </tr>
                <tr v-if="order.due_amount">
                    <td class="label-cell">Due</td>
                    <td class="value-cell">{{ formatAmountCurrency(order.due_amount) }}</td>
                </tr>
            </table>
        </div>

        <!-- Summary Row -->
        <div class="summary-row">
            <span>Items: {{ order.total_items }}</span>
            <span>Qty: {{ order.total_quantity }}</span>
        </div>

        <!-- Payment Mode -->
        <div class="payment-info" v-if="order.order_payments && order.order_payments.length > 0">
            <strong>Payment Mode:</strong>
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
            <div class="signatory-box">
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
    </div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
    name: "GstTheme1Invoice",
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
.gst-theme1-invoice {
    width: 100%;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11px;
    color: #333;
    line-height: 1.4;
}

.header-row {
    display: flex;
    align-items: flex-start;
    margin-bottom: 6px;
}

.header-company-box {
    flex: 1;
    background: #2c2c54;
    color: #fff;
    padding: 8px;
    border-radius: 2px;
}

.header-company-box p {
    margin: 0;
    font-size: 9px;
    color: #ddd;
}

.company-name {
    margin: 0 0 3px 0;
    font-size: 13px;
    color: #fff;
}

.header-logo-box {
    flex: 0 0 80px;
    text-align: right;
    padding-left: 8px;
    padding-top: 4px;
}

.company-logo {
    max-width: 70px;
    max-height: 50px;
    object-fit: contain;
}

.invoice-title-bar {
    background: #6c3483;
    color: #fff;
    text-align: center;
    padding: 4px 0;
    margin-bottom: 6px;
}

.invoice-title-bar h3 {
    margin: 0;
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 1px;
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
    background: #6c3483;
    color: #fff;
}

.items-table th {
    padding: 4px 2px;
    font-size: 9px;
    text-align: left;
    border: 1px solid #6c3483;
}

.items-table td {
    padding: 3px 2px;
    font-size: 10px;
    border-bottom: 1px solid #eee;
}

.col-sn { width: 5%; }
.col-item { width: 25%; }
.col-hsn { width: 13%; }
.col-qty { width: 10%; }
.col-rate { width: 16%; }
.col-tax { width: 14%; }
.col-amount { width: 17%; text-align: right; }

.amount-words {
    background: #f3e8ff;
    border: 1px solid #d5b8ff;
    padding: 4px 6px;
    margin-bottom: 6px;
    font-size: 10px;
}

.totals-section {
    margin-bottom: 6px;
}

.totals-table {
    width: 55%;
    margin-left: auto;
    border-collapse: collapse;
}

.totals-table td {
    padding: 2px 4px;
    font-size: 11px;
}

.label-cell {
    text-align: left;
}

.value-cell {
    text-align: right;
}

.grand-total-row td {
    border-top: 2px solid #6c3483;
    border-bottom: 2px solid #6c3483;
    font-size: 12px;
    padding: 4px;
    color: #6c3483;
}

.summary-row {
    display: flex;
    justify-content: space-around;
    background: #f5f5f5;
    padding: 3px 0;
    margin-bottom: 4px;
    font-size: 10px;
    font-weight: bold;
}

.payment-info {
    font-size: 10px;
    padding: 3px 4px;
    margin-bottom: 4px;
    border-bottom: 1px dashed #ddd;
}

.terms-section {
    margin-bottom: 8px;
    font-size: 9px;
    padding: 0 4px;
}

.terms-section p {
    margin: 2px 0 0 0;
}

.signatory-section {
    text-align: right;
    margin-top: 12px;
    padding: 0 4px;
}

.signatory-box {
    display: inline-block;
    text-align: center;
    border: 1px dashed #999;
    padding: 6px 12px;
}

.signatory-box p {
    margin: 2px 0;
    font-size: 10px;
}

.for-company {
    font-weight: bold;
    color: #6c3483;
}

.signature-img {
    max-width: 100px;
    max-height: 40px;
    object-fit: contain;
    display: block;
    margin: 4px auto;
}

.signatory-line {
    width: 110px;
    border-top: 1px solid #333;
    margin: 4px auto;
}
</style>
