<template>
    <div class="gst-distributor-invoice">
        <!-- Company Header -->
        <div class="invoice-header">
            <div class="header-left">
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
            <div class="header-right">
                <h2 class="company-name">
                    {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}
                </h2>
                <p class="company-address">
                    {{ selectedWarehouse ? selectedWarehouse.address : appSetting.address }}
                </p>
                <p v-if="(selectedWarehouse && selectedWarehouse.phone) || (appSetting && appSetting.phone)">
                    Phone: {{ selectedWarehouse ? selectedWarehouse.phone : appSetting.phone }}
                </p>
                <p v-if="(selectedWarehouse && selectedWarehouse.email) || (appSetting && appSetting.email)">
                    Email: {{ selectedWarehouse ? selectedWarehouse.email : appSetting.email }}
                </p>
                <p v-if="selectedWarehouse && selectedWarehouse.gstin" class="gstin-line">
                    <strong>GSTIN:</strong> {{ selectedWarehouse.gstin }}
                </p>
                <p v-if="selectedWarehouse && selectedWarehouse.state">
                    <strong>State:</strong> {{ selectedWarehouse.state }}
                    <span v-if="selectedWarehouse.state_code">
                        ({{ selectedWarehouse.state_code }})
                    </span>
                </p>
            </div>
        </div>

        <!-- Tax Invoice Title -->
        <div class="invoice-title">
            <h3>Tax Invoice</h3>
        </div>

        <!-- Invoice Details -->
        <table class="invoice-meta-table">
            <tr>
                <td><strong>Invoice No:</strong> {{ order.invoice_number }}</td>
                <td style="text-align: right"><strong>Date:</strong> {{ formatDate(order.order_date) }}</td>
            </tr>
            <tr v-if="order.e_way_bill_number">
                <td colspan="2"><strong>E-Way Bill No:</strong> {{ order.e_way_bill_number }}</td>
            </tr>
            <tr v-if="order.irn_number">
                <td colspan="2"><strong>IRN:</strong> {{ order.irn_number }}</td>
            </tr>
        </table>

        <!-- Bill To / Ship To -->
        <div class="bill-ship-section">
            <table class="bill-ship-table">
                <thead>
                    <tr>
                        <th>Bill To</th>
                        <th>Sold By</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <strong>{{ order.user ? order.user.name : '' }}</strong>
                            <br v-if="order.user && order.user.phone" />
                            <span v-if="order.user && order.user.phone">Phone: {{ order.user.phone }}</span>
                            <br v-if="order.user && order.user.tax_number" />
                            <span v-if="order.user && order.user.tax_number">
                                GSTIN: {{ order.user.tax_number }}
                            </span>
                        </td>
                        <td>
                            <span v-if="order.staff_member">{{ order.staff_member.name }}</span>
                        </td>
                    </tr>
                </tbody>
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

        <!-- Tax Breakup Table -->
        <div class="tax-breakup-section">
            <h4 class="section-heading">Tax Breakup</h4>
            <table class="tax-breakup-table">
                <thead>
                    <tr>
                        <th>HSN/SAC</th>
                        <th>Taxable Amt</th>
                        <th>CGST</th>
                        <th>SGST</th>
                        <th>IGST</th>
                        <th>Total Tax</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(item, index) in order.items" :key="'tax-' + index">
                        <td>{{ item.hsn_sac_code || (item.product ? item.product.hsn_sac_code : '') }}</td>
                        <td>{{ formatAmountCurrency(item.single_unit_price * item.quantity) }}</td>
                        <td>
                            <span v-if="item.tax_type === 'cgst_sgst' || item.tax_type === 'inclusive'">
                                {{ formatAmountCurrency(item.total_tax / 2) }}
                            </span>
                            <span v-else>-</span>
                        </td>
                        <td>
                            <span v-if="item.tax_type === 'cgst_sgst' || item.tax_type === 'inclusive'">
                                {{ formatAmountCurrency(item.total_tax / 2) }}
                            </span>
                            <span v-else>-</span>
                        </td>
                        <td>
                            <span v-if="item.tax_type === 'igst'">
                                {{ formatAmountCurrency(item.total_tax) }}
                            </span>
                            <span v-else>-</span>
                        </td>
                        <td>{{ formatAmountCurrency(item.total_tax) }}</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Totals Section -->
        <div class="totals-section">
            <table class="totals-table">
                <tr>
                    <td>Subtotal</td>
                    <td class="text-right">{{ formatAmountCurrency(order.subtotal) }}</td>
                </tr>
                <tr v-if="order.tax_amount">
                    <td>Tax ({{ order.tax_rate }}%)</td>
                    <td class="text-right">{{ formatAmountCurrency(order.tax_amount) }}</td>
                </tr>
                <tr v-if="order.discount">
                    <td>Discount</td>
                    <td class="text-right">- {{ formatAmountCurrency(order.discount) }}</td>
                </tr>
                <tr v-if="order.shipping">
                    <td>Shipping</td>
                    <td class="text-right">{{ formatAmountCurrency(order.shipping) }}</td>
                </tr>
                <tr class="grand-total-row">
                    <td><strong>Grand Total</strong></td>
                    <td class="text-right"><strong>{{ formatAmountCurrency(order.total) }}</strong></td>
                </tr>
                <tr>
                    <td>Paid Amount</td>
                    <td class="text-right">{{ formatAmountCurrency(order.paid_amount) }}</td>
                </tr>
                <tr v-if="order.due_amount">
                    <td>Due Amount</td>
                    <td class="text-right">{{ formatAmountCurrency(order.due_amount) }}</td>
                </tr>
            </table>
        </div>

        <!-- Amount in Words -->
        <div class="amount-words" v-if="amountInWords">
            <strong>Amount in Words:</strong> {{ amountInWords }}
        </div>

        <!-- QR Code Placeholder -->
        <div class="qr-section" v-if="order.irn_number">
            <div class="qr-placeholder">
                <small>QR Code</small>
            </div>
        </div>

        <!-- Payment Info -->
        <div class="payment-info" v-if="order.order_payments && order.order_payments.length > 0">
            <strong>Payment Mode:</strong>
            <span v-for="(payment, pIndex) in order.order_payments" :key="'pay-' + pIndex" class="payment-entry">
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
                <p>For {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</p>
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
    name: "GstDistributorInvoice",
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
.gst-distributor-invoice {
    max-width: 400px;
    margin: 0 auto;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11px;
    color: #333;
    line-height: 1.4;
}

.invoice-header {
    display: flex;
    align-items: flex-start;
    border-bottom: 2px solid #333;
    padding-bottom: 8px;
    margin-bottom: 6px;
}

.header-left {
    flex: 0 0 80px;
    margin-right: 10px;
}

.company-logo {
    max-width: 70px;
    max-height: 50px;
    object-fit: contain;
}

.header-right {
    flex: 1;
}

.header-right p {
    margin: 0;
    font-size: 10px;
}

.company-name {
    margin: 0 0 2px 0;
    font-size: 14px;
}

.company-address {
    font-size: 10px;
    margin: 0 0 2px 0;
}

.gstin-line {
    font-size: 11px;
}

.invoice-title {
    text-align: center;
    background: #333;
    color: #fff;
    padding: 4px 0;
    margin-bottom: 6px;
}

.invoice-title h3 {
    margin: 0;
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.invoice-meta-table {
    width: 100%;
    margin-bottom: 6px;
    border-collapse: collapse;
}

.invoice-meta-table td {
    padding: 2px 4px;
    font-size: 11px;
    border: 1px solid #ccc;
}

.bill-ship-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 6px;
}

.bill-ship-table th {
    background: #eee;
    padding: 3px 4px;
    text-align: left;
    font-size: 11px;
    border: 1px solid #ccc;
}

.bill-ship-table td {
    padding: 3px 4px;
    font-size: 10px;
    border: 1px solid #ccc;
    vertical-align: top;
}

.items-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 6px;
}

.items-table th {
    background: #333;
    color: #fff;
    padding: 3px 2px;
    font-size: 9px;
    text-align: left;
    border: 1px solid #333;
}

.items-table td {
    padding: 3px 2px;
    font-size: 10px;
    border: 1px solid #ccc;
    vertical-align: top;
}

.col-sn { width: 5%; }
.col-item { width: 25%; }
.col-hsn { width: 14%; }
.col-qty { width: 10%; }
.col-rate { width: 16%; }
.col-tax { width: 14%; }
.col-amount { width: 16%; text-align: right; }

.text-right {
    text-align: right;
}

.section-heading {
    margin: 4px 0;
    font-size: 11px;
    text-decoration: underline;
}

.tax-breakup-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 6px;
}

.tax-breakup-table th {
    background: #eee;
    padding: 2px 3px;
    font-size: 9px;
    text-align: left;
    border: 1px solid #ccc;
}

.tax-breakup-table td {
    padding: 2px 3px;
    font-size: 9px;
    border: 1px solid #ccc;
}

.totals-section {
    margin-bottom: 6px;
}

.totals-table {
    width: 100%;
    border-collapse: collapse;
}

.totals-table td {
    padding: 2px 4px;
    font-size: 11px;
    border-bottom: 1px dotted #ccc;
}

.grand-total-row td {
    border-top: 2px solid #333;
    border-bottom: 2px solid #333;
    padding: 4px;
    font-size: 12px;
}

.amount-words {
    background: #f5f5f5;
    padding: 4px 6px;
    margin-bottom: 6px;
    font-size: 10px;
    border: 1px solid #ccc;
}

.qr-section {
    text-align: center;
    margin-bottom: 6px;
}

.qr-placeholder {
    display: inline-block;
    width: 80px;
    height: 80px;
    border: 1px dashed #999;
    line-height: 80px;
    text-align: center;
    color: #999;
}

.payment-info {
    margin-bottom: 6px;
    font-size: 10px;
    padding: 3px 0;
    border-top: 1px dashed #ccc;
    border-bottom: 1px dashed #ccc;
}

.payment-entry {
    margin-left: 3px;
}

.terms-section {
    margin-bottom: 8px;
    font-size: 9px;
}

.terms-section p {
    margin: 2px 0 0 0;
}

.signatory-section {
    text-align: right;
    margin-top: 15px;
    padding-top: 8px;
}

.signatory-block {
    display: inline-block;
    text-align: center;
}

.signatory-block p {
    margin: 2px 0;
    font-size: 10px;
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
</style>
