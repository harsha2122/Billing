<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>{{ $order->invoice_number }}</title>

    <style>
        @page {
            margin: 15px;
            size: A4 portrait;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: DejaVu Sans, sans-serif;
            font-size: 11px;
            color: #333;
            line-height: 1.4;
            background: #fff;
        }

        .invoice-wrapper {
            max-width: 780px;
            margin: 0 auto;
            padding: 10px;
        }

        .accent { color: #0d8a72; }
        .accent-bg { background-color: #0d8a72; color: #fff; }
        .accent-border { border-color: #0d8a72; }
        .accent-light-bg { background-color: #e8f5f1; }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        .text-left { text-align: left; }
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .font-bold { font-weight: bold; }
        .font-sm { font-size: 10px; }
        .font-lg { font-size: 14px; }
        .font-xl { font-size: 16px; }

        .mt-5 { margin-top: 5px; }
        .mt-10 { margin-top: 10px; }
        .mt-15 { margin-top: 15px; }
        .mb-5 { margin-bottom: 5px; }
        .mb-10 { margin-bottom: 10px; }
        .p-5 { padding: 5px; }
        .p-8 { padding: 8px; }

        .border { border: 1px solid #0d8a72; }
        .border-bottom { border-bottom: 1px solid #0d8a72; }

        .header-section {
            border: 2px solid #0d8a72;
            padding: 10px;
        }

        .header-company-name {
            font-size: 20px;
            font-weight: bold;
            color: #0d8a72;
        }

        .eway-banner {
            background-color: #0d8a72;
            color: #fff;
            padding: 5px 10px;
            font-weight: bold;
            font-size: 12px;
            margin-top: 8px;
        }

        .section-title {
            background-color: #0d8a72;
            color: #fff;
            padding: 4px 8px;
            font-weight: bold;
            font-size: 11px;
        }

        .invoice-title {
            text-align: center;
            font-size: 16px;
            font-weight: bold;
            color: #0d8a72;
            padding: 6px 0;
            border-bottom: 2px solid #0d8a72;
            border-top: 2px solid #0d8a72;
            margin: 8px 0;
        }

        .items-table {
            border: 1px solid #0d8a72;
            margin-top: 8px;
        }

        .items-table th {
            background-color: #0d8a72;
            color: #fff;
            padding: 6px 5px;
            font-size: 10px;
            text-align: center;
            border-right: 1px solid rgba(255,255,255,0.3);
        }

        .items-table th:last-child {
            border-right: none;
        }

        .items-table td {
            padding: 5px;
            border-bottom: 1px solid #cde6df;
            border-right: 1px solid #cde6df;
            font-size: 10px;
            text-align: center;
        }

        .items-table td:last-child {
            border-right: none;
        }

        .items-table tr:last-child td {
            border-bottom: none;
        }

        .items-table .total-row td {
            background-color: #e8f5f1;
            font-weight: bold;
            border-top: 2px solid #0d8a72;
        }

        .gst-breakup-table {
            border: 1px solid #0d8a72;
            margin-top: 10px;
        }

        .gst-breakup-table th {
            background-color: #0d8a72;
            color: #fff;
            padding: 5px 4px;
            font-size: 9px;
            text-align: center;
            border-right: 1px solid rgba(255,255,255,0.3);
        }

        .gst-breakup-table th:last-child {
            border-right: none;
        }

        .gst-breakup-table td {
            padding: 4px;
            border-bottom: 1px solid #cde6df;
            border-right: 1px solid #cde6df;
            font-size: 9px;
            text-align: center;
        }

        .gst-breakup-table td:last-child {
            border-right: none;
        }

        .totals-table td {
            padding: 4px 8px;
            font-size: 11px;
        }

        .totals-table .total-label {
            text-align: right;
            font-weight: bold;
            width: 70%;
        }

        .totals-table .total-value {
            text-align: right;
            width: 30%;
        }

        .totals-table .grand-total td {
            background-color: #0d8a72;
            color: #fff;
            font-weight: bold;
            font-size: 12px;
        }

        .amount-words {
            background-color: #e8f5f1;
            border: 1px solid #0d8a72;
            padding: 6px 10px;
            font-size: 11px;
            margin-top: 8px;
        }

        .terms-section {
            margin-top: 10px;
            font-size: 10px;
        }

        .signature-section {
            text-align: right;
            margin-top: 15px;
        }

        .signature-box {
            display: inline-block;
            text-align: center;
            border-top: 1px dashed #0d8a72;
            padding-top: 5px;
            min-width: 200px;
        }

        .einvoice-section {
            border: 1px solid #0d8a72;
            margin-top: 10px;
            padding: 8px;
        }

        .einvoice-section .section-heading {
            background-color: #0d8a72;
            color: #fff;
            padding: 4px 8px;
            font-weight: bold;
            margin: -8px -8px 8px -8px;
        }

        .clearfix::after {
            content: "";
            display: table;
            clear: both;
        }
    </style>
</head>

<body>
    <div class="invoice-wrapper">

        {{-- HEADER SECTION --}}
        <div class="header-section">
            <table>
                <tr>
                    <td style="width: 15%; vertical-align: middle;">
                        @if($order->warehouse && $order->warehouse->logo_url)
                            <img src="{{ $order->warehouse->logo_url }}" style="max-width: 100px; max-height: 60px;" />
                        @elseif($company->light_logo_url)
                            <img src="{{ $company->light_logo_url }}" style="max-width: 100px; max-height: 60px;" />
                        @endif
                    </td>
                    <td style="width: 55%; vertical-align: middle;">
                        <div class="header-company-name">{{ $order->warehouse ? $order->warehouse->name : $company->name }}</div>
                        @php
                            $headerAddress = $order->warehouse ? $order->warehouse->address : $company->address;
                        @endphp
                        @if($headerAddress)
                            <div style="margin-top: 3px;">{{ $headerAddress }}</div>
                        @endif
                        <div>
                            @php
                                $headerPhone = $order->warehouse ? $order->warehouse->phone : $company->phone;
                                $headerEmail = $order->warehouse ? $order->warehouse->email : $company->email;
                            @endphp
                            @if($headerPhone)
                                {{ $traslations['phone'] ?? 'Phone' }}: {{ $headerPhone }}
                            @endif
                            @if($headerEmail)
                                | {{ $traslations['email'] ?? 'Email' }}: {{ $headerEmail }}
                            @endif
                        </div>
                        @if($order->warehouse && $order->warehouse->gstin)
                            <div class="font-bold mt-5">GSTIN: {{ $order->warehouse->gstin }}</div>
                        @endif
                        @if($order->warehouse && $order->warehouse->state)
                            <div>State: {{ $order->warehouse->state }}
                                @if($order->warehouse->state_code)
                                    | Code: {{ $order->warehouse->state_code }}
                                @endif
                            </div>
                        @endif
                    </td>
                    <td style="width: 30%; vertical-align: middle; text-align: right;">
                        <div class="font-bold">{{ $traslations['invoice'] ?? 'Invoice' }} #: {{ $order->invoice_number }}</div>
                        <div>{{ $traslations['order_date'] ?? 'Date' }}: {{ $order->order_date->format($dateTimeFormat) }}</div>
                        @if($order->staffMember)
                            <div>{{ $traslations['staff_member'] ?? 'Staff' }}: {{ $order->staffMember->name }}</div>
                        @endif
                    </td>
                </tr>
            </table>
        </div>

        {{-- E-WAY BILL BANNER --}}
        @if($order->e_way_bill_number)
            <div class="eway-banner">
                E-Way Bill No: {{ $order->e_way_bill_number }}
            </div>
        @endif

        {{-- TAX INVOICE TITLE --}}
        <div class="invoice-title">{{ $traslations['tax_invoice'] ?? 'Tax Invoice' }}</div>

        {{-- BILL TO / SHIP TO SECTION --}}
        <table style="margin-top: 5px;">
            <tr>
                <td style="width: 50%; vertical-align: top; padding-right: 10px;">
                    <div class="section-title">{{ $traslations['bill_to'] ?? 'Bill To' }}</div>
                    <div style="border: 1px solid #0d8a72; border-top: none; padding: 8px;">
                        <div class="font-bold">{{ $order->user->name }}</div>
                        @if($order->user->address)
                            <div>{{ $order->user->address }}</div>
                        @endif
                        @if($order->user->phone)
                            <div>{{ $traslations['phone'] ?? 'Phone' }}: {{ $order->user->phone }}</div>
                        @endif
                        @if($order->user->email)
                            <div>{{ $traslations['email'] ?? 'Email' }}: {{ $order->user->email }}</div>
                        @endif
                        @if($order->user->tax_number)
                            <div class="font-bold">GSTIN: {{ $order->user->tax_number }}</div>
                        @endif
                    </div>
                </td>
                <td style="width: 50%; vertical-align: top; padding-left: 10px;">
                    @if($order->warehouse)
                        <div class="section-title">{{ $traslations['warehouse'] ?? 'Ship From' }}</div>
                        <div style="border: 1px solid #0d8a72; border-top: none; padding: 8px;">
                            <div class="font-bold">{{ $order->warehouse->name }}</div>
                            @if($order->warehouse->address)
                                <div>{{ $order->warehouse->address }}</div>
                            @endif
                            @if($order->warehouse->phone)
                                <div>{{ $traslations['phone'] ?? 'Phone' }}: {{ $order->warehouse->phone }}</div>
                            @endif
                            @if($order->warehouse->gstin)
                                <div class="font-bold">GSTIN: {{ $order->warehouse->gstin }}</div>
                            @endif
                            @if($order->warehouse->state)
                                <div>State: {{ $order->warehouse->state }}
                                    @if($order->warehouse->state_code)
                                        | Code: {{ $order->warehouse->state_code }}
                                    @endif
                                </div>
                            @endif
                        </div>
                    @endif
                </td>
            </tr>
        </table>

        {{-- ITEMS TABLE --}}
        @php
            $sellerStateCode = $order->warehouse ? $order->warehouse->state_code : ($company->state_code ?? '');
            $buyerStateCode = $order->user->state_code ?? '';
            $itemGstBreakups = [];
        @endphp

        <table class="items-table">
            <thead>
                <tr>
                    <th style="width: 5%;">#</th>
                    <th style="width: 28%;">{{ $traslations['product'] ?? 'Item Name' }}</th>
                    <th style="width: 10%;">HSN/SAC</th>
                    <th style="width: 10%;">{{ $traslations['quantity'] ?? 'Qty' }}</th>
                    <th style="width: 12%;">{{ $traslations['unit_price'] ?? 'Price/Unit' }}</th>
                    <th style="width: 10%;">GST (%)</th>
                    <th style="width: 12%;">GST Amt</th>
                    <th style="width: 13%;">{{ $traslations['total'] ?? 'Amount' }}</th>
                </tr>
            </thead>
            <tbody>
                @foreach($order->items as $item)
                    @php
                        $hsnCode = $item->hsn_sac_code ?? $item->product->hsn_sac_code;
                        $taxableAmount = $item->subtotal;
                        $itemTaxRate = $item->tax_rate ?? 0;
                        $itemGst = \App\Classes\Common::getItemGstBreakup($itemTaxRate, $taxableAmount, $sellerStateCode, $buyerStateCode);
                        $itemGstBreakups[] = [
                            'hsn_code' => $hsnCode,
                            'tax_rate' => $itemTaxRate,
                            'taxable_amount' => $taxableAmount,
                            'breakup' => $itemGst,
                        ];
                    @endphp
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td class="text-left" style="padding-left: 8px;">{{ $item->product->name }}</td>
                        <td>{{ $hsnCode ?? '-' }}</td>
                        <td>{{ $item->quantity }} {{ $item->unit->short_name }}</td>
                        <td class="text-right">{{ $company->currency->symbol }}{{ $item->single_unit_price }}</td>
                        <td>{{ $itemTaxRate }}%</td>
                        <td class="text-right">{{ $company->currency->symbol }}{{ $itemGst['total_tax'] }}</td>
                        <td class="text-right">{{ $company->currency->symbol }}{{ $item->subtotal + $itemGst['total_tax'] }}</td>
                    </tr>
                @endforeach

                <tr class="total-row">
                    <td colspan="4" class="text-right font-bold">{{ $traslations['total'] ?? 'Total' }}</td>
                    <td class="text-right">{{ $company->currency->symbol }}{{ $order->subtotal }}</td>
                    <td></td>
                    <td class="text-right">{{ $company->currency->symbol }}{{ $order->tax_amount }}</td>
                    <td class="text-right">{{ $company->currency->symbol }}{{ $order->total }}</td>
                </tr>
            </tbody>
        </table>

        {{-- GST TAX BREAKUP TABLE --}}
        @if($gstBreakup)
            <table class="gst-breakup-table">
                <thead>
                    <tr>
                        <th rowspan="2" style="width: 15%;">HSN/SAC</th>
                        <th rowspan="2" style="width: 15%;">Taxable Amount</th>
                        @if($gstBreakup['type'] == 'igst')
                            <th colspan="2" style="width: 25%;">IGST</th>
                        @else
                            <th colspan="2" style="width: 25%;">CGST</th>
                            <th colspan="2" style="width: 25%;">SGST</th>
                        @endif
                        <th rowspan="2" style="width: 15%;">Total Tax</th>
                    </tr>
                    <tr>
                        @if($gstBreakup['type'] == 'igst')
                            <th>Rate</th>
                            <th>Amount</th>
                        @else
                            <th>Rate</th>
                            <th>Amount</th>
                            <th>Rate</th>
                            <th>Amount</th>
                        @endif
                    </tr>
                </thead>
                <tbody>
                    @foreach($itemGstBreakups as $gstItem)
                        <tr>
                            <td>{{ $gstItem['hsn_code'] ?? '-' }}</td>
                            <td>{{ $company->currency->symbol }}{{ number_format($gstItem['taxable_amount'], 2) }}</td>
                            @if($gstBreakup['type'] == 'igst')
                                <td>{{ $gstItem['breakup']['igst_rate'] }}%</td>
                                <td>{{ $company->currency->symbol }}{{ number_format($gstItem['breakup']['igst_amount'], 2) }}</td>
                            @else
                                <td>{{ $gstItem['breakup']['cgst_rate'] }}%</td>
                                <td>{{ $company->currency->symbol }}{{ number_format($gstItem['breakup']['cgst_amount'], 2) }}</td>
                                <td>{{ $gstItem['breakup']['sgst_rate'] }}%</td>
                                <td>{{ $company->currency->symbol }}{{ number_format($gstItem['breakup']['sgst_amount'], 2) }}</td>
                            @endif
                            <td>{{ $company->currency->symbol }}{{ number_format($gstItem['breakup']['total_tax'], 2) }}</td>
                        </tr>
                    @endforeach

                    {{-- Totals row --}}
                    <tr style="font-weight: bold; background-color: #e8f5f1;">
                        <td>Total</td>
                        <td>{{ $company->currency->symbol }}{{ number_format($order->subtotal, 2) }}</td>
                        @if($gstBreakup['type'] == 'igst')
                            <td></td>
                            <td>{{ $company->currency->symbol }}{{ number_format($gstBreakup['igst'], 2) }}</td>
                        @else
                            <td></td>
                            <td>{{ $company->currency->symbol }}{{ number_format($gstBreakup['cgst'], 2) }}</td>
                            <td></td>
                            <td>{{ $company->currency->symbol }}{{ number_format($gstBreakup['sgst'], 2) }}</td>
                        @endif
                        <td>{{ $company->currency->symbol }}{{ number_format($order->tax_amount, 2) }}</td>
                    </tr>
                </tbody>
            </table>
        @endif

        {{-- INVOICE AMOUNT IN WORDS --}}
        <div class="amount-words">
            <span class="font-bold">{{ $traslations['amount_in_words'] ?? 'Invoice Amount in Words' }}:</span>
            {{ $amountInWords }}
        </div>

        {{-- TOTALS SECTION --}}
        <table class="totals-table" style="margin-top: 8px;">
            <tr>
                <td class="total-label">{{ $traslations['subtotal'] ?? 'Sub Total' }}:</td>
                <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->subtotal, 2) }}</td>
            </tr>
            @if($order->discount > 0)
                <tr>
                    <td class="total-label">{{ $traslations['discount'] ?? 'Discount' }}:</td>
                    <td class="total-value">- {{ $company->currency->symbol }}{{ number_format($order->discount, 2) }}</td>
                </tr>
            @endif
            @if($order->shipping > 0)
                <tr>
                    <td class="total-label">{{ $traslations['shipping'] ?? 'Shipping' }}:</td>
                    <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->shipping, 2) }}</td>
                </tr>
            @endif
            <tr>
                <td class="total-label">{{ $traslations['tax'] ?? 'Tax' }}:</td>
                <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->tax_amount, 2) }}</td>
            </tr>
            <tr class="grand-total">
                <td class="total-label">{{ $traslations['total'] ?? 'Total' }}:</td>
                <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->total, 2) }}</td>
            </tr>
            <tr>
                <td class="total-label">{{ $traslations['paid_amount'] ?? 'Received' }}:</td>
                <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->paid_amount, 2) }}</td>
            </tr>
            <tr>
                <td class="total-label" style="color: #c00;">{{ $traslations['due_amount'] ?? 'Balance' }}:</td>
                <td class="total-value" style="color: #c00;">{{ $company->currency->symbol }}{{ number_format($order->due_amount, 2) }}</td>
            </tr>
        </table>

        {{-- PAYMENT DETAILS --}}
        @if($order->orderPayments && count($order->orderPayments) > 0)
            <div style="margin-top: 8px; font-size: 10px;">
                <span class="font-bold">{{ $traslations['payment_mode'] ?? 'Payment Mode' }}:</span>
                @foreach($order->orderPayments as $currentOrderPayment)
                    <span style="margin-right: 8px;">
                        {{ $company->currency->symbol }}{{ $currentOrderPayment->amount }}
                        @if($currentOrderPayment->payment && $currentOrderPayment->payment->paymentMode && $currentOrderPayment->payment->paymentMode->name)
                            ({{ $currentOrderPayment->payment->paymentMode->name }})
                        @endif
                    </span>
                @endforeach
            </div>
        @endif

        {{-- TERMS & CONDITIONS --}}
        @php
            $terms = $order->terms_condition ?? ($order->warehouse ? $order->warehouse->terms_condition : '');
        @endphp
        @if($terms)
            <div class="terms-section">
                <div class="font-bold accent">{{ $traslations['terms_conditions'] ?? 'Terms & Conditions' }}:</div>
                <div style="margin-top: 3px;">{!! nl2br(e($terms)) !!}</div>
            </div>
        @endif

        {{-- AUTHORIZED SIGNATORY --}}
        <table style="margin-top: 20px;">
            <tr>
                <td style="width: 60%; vertical-align: bottom;">
                    {{-- e-Invoice Section --}}
                    @if($order->irn_number || $order->qr_code_data)
                        <div class="einvoice-section">
                            <div class="section-heading">e-Invoice Details</div>
                            <table>
                                <tr>
                                    @if($order->qr_code_data)
                                        <td style="width: 120px; vertical-align: top;">
                                            <div style="border: 1px solid #ccc; padding: 5px; width: 100px; height: 100px; text-align: center; line-height: 90px; font-size: 9px; color: #999;">
                                                QR Code
                                            </div>
                                        </td>
                                    @endif
                                    <td style="vertical-align: top;">
                                        @if($order->irn_number)
                                            <div class="font-bold">IRN Number:</div>
                                            <div style="font-size: 9px; word-break: break-all;">{{ $order->irn_number }}</div>
                                        @endif
                                    </td>
                                </tr>
                            </table>
                        </div>
                    @endif
                </td>
                <td style="width: 40%; text-align: right; vertical-align: bottom;">
                    <div>
                        <div class="font-bold" style="margin-bottom: 5px;">For {{ $order->warehouse ? $order->warehouse->name : $company->name }}</div>
                        @if($order->warehouse && $order->warehouse->signature)
                            <img src="{{ $order->warehouse->signature_url }}" style="max-width: 150px; max-height: 60px;" />
                            <br>
                        @endif
                        <div class="signature-box">
                            {{ $traslations['authorized_signatory'] ?? 'Authorized Signatory' }}
                        </div>
                    </div>
                </td>
            </tr>
        </table>

    </div>
</body>

</html>
