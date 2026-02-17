<template>
    <div class="pos-tpl gst-distributor-invoice">
        <!-- Company Header -->
        <div class="invoice-header">
            <div class="header-left">
                <img
                    v-if="selectedWarehouse && selectedWarehouse.logo_url"
                    :src="selectedWarehouse.logo_url"
                    :alt="selectedWarehouse.name"
                    class="company-logo"
                />
            </div>
            <div class="header-right">
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
                    <strong>GSTIN:</strong> {{ selectedWarehouse.gstin }}
                </p>
                <p v-if="selectedWarehouse && selectedWarehouse.state">
                    <strong>State:</strong> {{ selectedWarehouse.state }}
                    <span v-if="selectedWarehouse.state_code">({{ selectedWarehouse.state_code }})</span>
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
                <td class="text-right"><strong>Date:</strong> {{ formatDate(order.order_date) }}</td>
            </tr>
            <tr v-if="order.e_way_bill_number">
                <td colspan="2"><strong>E-Way Bill No:</strong> {{ order.e_way_bill_number }}</td>
            </tr>
            <tr v-if="order.irn_number">
                <td colspan="2"><strong>IRN:</strong> {{ order.irn_number }}</td>
            </tr>
        </table>

        <!-- Bill To / Sold By -->
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
                        <span v-if="order.user && order.user.tax_number">GSTIN: {{ order.user.tax_number }}</span>
                    </td>
                    <td>
                        <span v-if="order.staff_member">{{ order.staff_member.name }}</span>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- Items Table -->
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
                            <span v-if="item.tax_type === 'cgst_sgst' || item.tax_type === 'inclusive'">{{ formatAmountCurrency(item.total_tax / 2) }}</span>
                            <span v-else>-</span>
                        </td>
                        <td>
                            <span v-if="item.tax_type === 'cgst_sgst' || item.tax_type === 'inclusive'">{{ formatAmountCurrency(item.total_tax / 2) }}</span>
                            <span v-else>-</span>
                        </td>
                        <td>
                            <span v-if="item.tax_type === 'igst'">{{ formatAmountCurrency(item.total_tax) }}</span>
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

        <!-- Payment Info -->
        <div class="payment-info" v-if="order.order_payments && order.order_payments.length > 0">
            <strong>Payment Mode:</strong>
            <span v-for="(payment, pIndex) in order.order_payments" :key="'pay-' + pIndex">
                {{ formatAmountCurrency(payment.amount) }}
                <span v-if="payment.payment && payment.payment.payment_mode">({{ payment.payment.payment_mode.name }})</span>
                <span v-if="pIndex < order.order_payments.length - 1">, </span>
            </span>
        </div>

        <!-- Bank Details -->
        <div class="bank-details-section" v-if="selectedWarehouse && selectedWarehouse.bank_details" style="margin-bottom:8px;font-size:10px;">
            <strong>Bank Details:</strong>
            <p style="white-space:pre-line;margin:2px 0 0 0;">{{ selectedWarehouse.bank_details }}</p>
        </div>

        <!-- Terms -->
        <div class="terms-section" v-if="order.terms_condition || (selectedWarehouse && selectedWarehouse.terms_condition)">
            <strong>Terms & Conditions:</strong>
            <p>{{ order.terms_condition || (selectedWarehouse ? selectedWarehouse.terms_condition : '') }}</p>
        </div>

        <!-- Signatory -->
        <div class="signatory-section">
            <div class="signatory-block">
                <p>For {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</p>
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
    name: "GstDistributorInvoice",
    props: ["order", "appSetting", "selectedWarehouse", "formatAmountCurrency", "formatDate", "amountInWords"],
});
</script>

<style>
.gst-distributor-invoice {
    width: 100%;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    font-size: 11px;
    color: #1a1a1a;
    line-height: 1.5;
}
.gst-distributor-invoice .invoice-header {
    display: flex;
    align-items: flex-start;
    border-bottom: 2px solid #0d9488;
    padding-bottom: 10px;
    margin-bottom: 8px;
}
.gst-distributor-invoice .header-left { flex: 0 0 80px; margin-right: 12px; }
.gst-distributor-invoice .company-logo { max-width: 70px; max-height: 50px; object-fit: contain; }
.gst-distributor-invoice .header-right { flex: 1; }
.gst-distributor-invoice .header-right p { margin: 0; font-size: 10px; color: #555; }
.gst-distributor-invoice .company-name { margin: 0 0 3px 0; font-size: 15px; color: #0d9488; font-weight: 700; }
.gst-distributor-invoice .invoice-title { text-align: center; background: #0d9488; color: #fff; padding: 5px 0; margin-bottom: 8px; }
.gst-distributor-invoice .invoice-title h3 { margin: 0; font-size: 12px; text-transform: uppercase; letter-spacing: 1.5px; font-weight: 600; color: #fff; }
.gst-distributor-invoice .invoice-meta-table { width: 100%; margin-bottom: 8px; border-collapse: collapse; }
.gst-distributor-invoice .invoice-meta-table td { padding: 4px 6px; font-size: 11px; border: 1px solid #e0e0e0; }
.gst-distributor-invoice .bill-ship-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; }
.gst-distributor-invoice .bill-ship-table th { background: #f0fdfa; color: #0d9488; padding: 5px 8px; text-align: left; font-size: 11px; border: 1px solid #e0e0e0; font-weight: 600; }
.gst-distributor-invoice .bill-ship-table td { padding: 5px 8px; font-size: 10px; border: 1px solid #e0e0e0; vertical-align: top; }
.gst-distributor-invoice .items-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; }
.gst-distributor-invoice .items-table th { background: #0d9488; color: #fff; padding: 5px 6px; font-size: 9px; text-align: left; font-weight: 600; text-transform: uppercase; letter-spacing: 0.3px; }
.gst-distributor-invoice .items-table td { padding: 5px 6px; font-size: 10px; border-bottom: 1px solid #eee; vertical-align: top; }
.gst-distributor-invoice .items-table tbody tr:nth-child(even) { background: #fafafa; }
.gst-distributor-invoice .text-right { text-align: right; }
.gst-distributor-invoice .section-heading { margin: 6px 0 4px; font-size: 11px; color: #0d9488; font-weight: 600; border-bottom: 1px solid #0d9488; padding-bottom: 2px; display: inline-block; }
.gst-distributor-invoice .tax-breakup-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; }
.gst-distributor-invoice .tax-breakup-table th { background: #f0fdfa; padding: 4px 6px; font-size: 9px; text-align: left; border: 1px solid #e0e0e0; color: #0d9488; font-weight: 600; text-transform: uppercase; }
.gst-distributor-invoice .tax-breakup-table td { padding: 4px 6px; font-size: 9px; border: 1px solid #e0e0e0; }
.gst-distributor-invoice .totals-section { margin-bottom: 8px; }
.gst-distributor-invoice .totals-table { width: 50%; margin-left: auto; border-collapse: collapse; }
.gst-distributor-invoice .totals-table td { padding: 3px 6px; font-size: 11px; border-bottom: 1px solid #f0f0f0; }
.gst-distributor-invoice .grand-total-row td { border-top: 2px solid #0d9488; border-bottom: 2px solid #0d9488; padding: 5px 6px; font-size: 12px; color: #0d9488; }
.gst-distributor-invoice .amount-words { background: #f0fdfa; padding: 5px 8px; margin-bottom: 8px; font-size: 10px; border-left: 3px solid #0d9488; }
.gst-distributor-invoice .payment-info { margin-bottom: 8px; font-size: 10px; padding: 4px 0; border-top: 1px dashed #ddd; border-bottom: 1px dashed #ddd; }
.gst-distributor-invoice .terms-section { margin-bottom: 10px; font-size: 9px; color: #666; }
.gst-distributor-invoice .terms-section p { margin: 2px 0 0 0; }
.gst-distributor-invoice .signatory-section { text-align: right; margin-top: 16px; }
.gst-distributor-invoice .signatory-block { display: inline-block; text-align: center; }
.gst-distributor-invoice .signatory-block p { margin: 2px 0; font-size: 10px; }
.gst-distributor-invoice .signature-img { max-width: 100px; max-height: 40px; object-fit: contain; display: block; margin: 4px auto; }
.gst-distributor-invoice .signatory-line { width: 120px; border-top: 1px solid #333; margin: 4px auto; }
</style>
