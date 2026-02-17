<template>
    <div class="pos-tpl gst-theme2-invoice">
        <div class="top-title-bar"><h3>Tax Invoice</h3></div>
        <div class="header-section">
            <div class="header-logo" v-if="selectedWarehouse && selectedWarehouse.logo_url">
                <img :src="selectedWarehouse.logo_url" :alt="selectedWarehouse.name" class="company-logo" />
            </div>
            <div class="header-company-info">
                <h2 class="company-name">{{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</h2>
                <p>{{ selectedWarehouse ? selectedWarehouse.address : appSetting.address }}</p>
                <p v-if="(selectedWarehouse && selectedWarehouse.phone) || (appSetting && appSetting.phone)">Phone: {{ selectedWarehouse ? selectedWarehouse.phone : appSetting.phone }}</p>
                <p v-if="(selectedWarehouse && selectedWarehouse.email) || (appSetting && appSetting.email)">Email: {{ selectedWarehouse ? selectedWarehouse.email : appSetting.email }}</p>
                <p v-if="selectedWarehouse && selectedWarehouse.gstin">GSTIN: {{ selectedWarehouse.gstin }}</p>
            </div>
        </div>
        <table class="meta-table">
            <tr>
                <td><strong>Invoice No:</strong> {{ order.invoice_number }}</td>
                <td class="text-right"><strong>Date:</strong> {{ formatDate(order.order_date) }}</td>
            </tr>
        </table>
        <div class="bill-to-bar">Bill To</div>
        <table class="customer-table">
            <tr>
                <td><strong>{{ order.user ? order.user.name : '' }}</strong></td>
                <td class="text-right"><span v-if="order.staff_member">Sold By: {{ order.staff_member.name }}</span></td>
            </tr>
            <tr v-if="order.user && (order.user.phone || order.user.tax_number)">
                <td><span v-if="order.user.phone">Phone: {{ order.user.phone }}</span></td>
                <td class="text-right"><span v-if="order.user.tax_number">GSTIN: {{ order.user.tax_number }}</span></td>
            </tr>
        </table>
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width:5%">#</th>
                    <th style="width:26%">Item</th>
                    <th style="width:13%">HSN/SAC</th>
                    <th style="width:10%">Qty</th>
                    <th style="width:16%">Rate</th>
                    <th style="width:14%">Tax</th>
                    <th style="width:16%; text-align:right">Amount</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(item, index) in order.items" :key="index">
                    <td>{{ index + 1 }}</td>
                    <td>{{ item.product ? item.product.name : '' }}</td>
                    <td>{{ item.hsn_sac_code || (item.product ? item.product.hsn_sac_code : '') }}</td>
                    <td>{{ item.quantity }}{{ item.unit ? item.unit.short_name : '' }}</td>
                    <td>{{ formatAmountCurrency(item.single_unit_price) }}</td>
                    <td><span v-if="item.total_tax">{{ formatAmountCurrency(item.total_tax) }}</span><span v-else>-</span></td>
                    <td class="text-right">{{ formatAmountCurrency(item.subtotal) }}</td>
                </tr>
            </tbody>
        </table>
        <div class="amounts-section">
            <table class="amounts-table">
                <tr><td>Subtotal</td><td class="text-right">{{ formatAmountCurrency(order.subtotal) }}</td></tr>
                <tr v-if="order.tax_amount"><td>Tax ({{ order.tax_rate }}%)</td><td class="text-right">{{ formatAmountCurrency(order.tax_amount) }}</td></tr>
                <tr v-if="order.discount"><td>Discount</td><td class="text-right">- {{ formatAmountCurrency(order.discount) }}</td></tr>
                <tr v-if="order.shipping"><td>Shipping</td><td class="text-right">{{ formatAmountCurrency(order.shipping) }}</td></tr>
                <tr class="grand-total-row"><td><strong>Total</strong></td><td class="text-right"><strong>{{ formatAmountCurrency(order.total) }}</strong></td></tr>
                <tr><td>Paid Amount</td><td class="text-right">{{ formatAmountCurrency(order.paid_amount) }}</td></tr>
                <tr v-if="order.due_amount"><td>Due Amount</td><td class="text-right">{{ formatAmountCurrency(order.due_amount) }}</td></tr>
            </table>
        </div>
        <div class="amount-words-bar" v-if="amountInWords"><strong>Amount in Words:</strong> {{ amountInWords }}</div>
        <div class="payment-info" v-if="order.order_payments && order.order_payments.length > 0">
            <strong>Payment Mode:</strong>
            <span v-for="(payment, pIndex) in order.order_payments" :key="'pay-' + pIndex">
                {{ formatAmountCurrency(payment.amount) }}
                <span v-if="payment.payment && payment.payment.payment_mode">({{ payment.payment.payment_mode.name }})</span>
                <span v-if="pIndex < order.order_payments.length - 1">, </span>
            </span>
        </div>
        <div class="bank-details-section" v-if="selectedWarehouse && selectedWarehouse.bank_details" style="margin-bottom:8px;font-size:10px;">
            <strong>Bank Details:</strong>
            <p style="white-space:pre-line;margin:2px 0 0 0;">{{ selectedWarehouse.bank_details }}</p>
        </div>
        <div class="terms-section" v-if="order.terms_condition || (selectedWarehouse && selectedWarehouse.terms_condition)">
            <strong>Terms & Conditions:</strong>
            <p>{{ order.terms_condition || (selectedWarehouse ? selectedWarehouse.terms_condition : '') }}</p>
        </div>
        <div class="signatory-section">
            <div class="signatory-block">
                <p class="for-company">For {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</p>
                <img v-if="selectedWarehouse && selectedWarehouse.signature_url" :src="selectedWarehouse.signature_url" alt="Signature" class="signature-img" />
                <div class="signatory-line"></div>
                <p>Authorized Signatory</p>
            </div>
        </div>
    </div>
</template>

<script>
import { defineComponent } from "vue";
export default defineComponent({
    name: "GstTheme2Invoice",
    props: ["order", "appSetting", "selectedWarehouse", "formatAmountCurrency", "formatDate", "amountInWords"],
});
</script>

<style>
.gst-theme2-invoice { width: 100%; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; font-size: 11px; color: #1a1a1a; line-height: 1.5; }
.gst-theme2-invoice .top-title-bar { background: #6c63ff; color: #fff; text-align: center; padding: 6px 0; margin-bottom: 10px; }
.gst-theme2-invoice .top-title-bar h3 { margin: 0; font-size: 13px; text-transform: uppercase; letter-spacing: 1.5px; font-weight: 600; color: #fff; }
.gst-theme2-invoice .header-section { display: flex; align-items: flex-start; justify-content: flex-end; margin-bottom: 8px; padding: 0 4px; }
.gst-theme2-invoice .header-logo { margin-right: 12px; }
.gst-theme2-invoice .company-logo { max-width: 60px; max-height: 45px; object-fit: contain; }
.gst-theme2-invoice .header-company-info { text-align: right; flex: 1; }
.gst-theme2-invoice .company-name { margin: 0 0 3px 0; font-size: 15px; color: #6c63ff; font-weight: 700; }
.gst-theme2-invoice .header-company-info p { margin: 0; font-size: 10px; color: #555; }
.gst-theme2-invoice .meta-table { width: 100%; border-collapse: collapse; margin-bottom: 6px; }
.gst-theme2-invoice .meta-table td { padding: 4px 6px; font-size: 11px; }
.gst-theme2-invoice .text-right { text-align: right; }
.gst-theme2-invoice .bill-to-bar { background: #6c63ff; color: #fff; padding: 4px 10px; font-size: 11px; font-weight: 600; margin-bottom: 6px; letter-spacing: 0.5px; }
.gst-theme2-invoice .customer-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; }
.gst-theme2-invoice .customer-table td { padding: 3px 6px; font-size: 10px; }
.gst-theme2-invoice .items-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; }
.gst-theme2-invoice .items-table thead tr { background: #6c63ff; color: #fff; }
.gst-theme2-invoice .items-table th { padding: 6px; font-size: 9px; text-align: left; font-weight: 600; text-transform: uppercase; letter-spacing: 0.3px; color: #fff; }
.gst-theme2-invoice .items-table td { padding: 5px 6px; font-size: 10px; border-bottom: 1px solid #f0f0f0; }
.gst-theme2-invoice .items-table tbody tr:nth-child(even) { background: #fafafa; }
.gst-theme2-invoice .amounts-section { margin-bottom: 8px; }
.gst-theme2-invoice .amounts-table { width: 50%; margin-left: auto; border-collapse: collapse; }
.gst-theme2-invoice .amounts-table td { padding: 3px 6px; font-size: 11px; border-bottom: 1px solid #f0f0f0; }
.gst-theme2-invoice .grand-total-row td { border-top: 2px solid #6c63ff; border-bottom: 2px solid #6c63ff; padding: 5px 6px; font-size: 12px; color: #6c63ff; }
.gst-theme2-invoice .amount-words-bar { background: #6c63ff; color: #fff; padding: 5px 10px; font-size: 10px; margin-bottom: 8px; }
.gst-theme2-invoice .payment-info { font-size: 10px; padding: 4px 6px; margin-bottom: 6px; border-bottom: 1px dashed #e0e0e0; }
.gst-theme2-invoice .terms-section { margin-bottom: 10px; font-size: 9px; color: #666; padding: 0 4px; }
.gst-theme2-invoice .terms-section p { margin: 2px 0 0 0; }
.gst-theme2-invoice .signatory-section { text-align: right; margin-top: 14px; padding: 0 4px; }
.gst-theme2-invoice .signatory-block { display: inline-block; text-align: center; }
.gst-theme2-invoice .signatory-block p { margin: 2px 0; font-size: 10px; }
.gst-theme2-invoice .for-company { font-weight: 600; color: #6c63ff; }
.gst-theme2-invoice .signature-img { max-width: 100px; max-height: 40px; object-fit: contain; display: block; margin: 4px auto; }
.gst-theme2-invoice .signatory-line { width: 120px; border-top: 1px solid #333; margin: 4px auto; }
</style>
