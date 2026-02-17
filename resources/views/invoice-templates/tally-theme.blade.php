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
            border: 2px solid #1976D2;
        }

        .accent { color: #1976D2; }
        .accent-bg { background-color: #1976D2; color: #fff; }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        .text-left { text-align: left; }
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .font-bold { font-weight: bold; }
        .font-sm { font-size: 10px; }

        .mt-5 { margin-top: 5px; }
        .mt-10 { margin-top: 10px; }
        .mt-15 { margin-top: 15px; }
        .mb-5 { margin-bottom: 5px; }

        /* Tax Invoice title centered bold */
        .invoice-title {
            text-align: center;
            font-size: 18px;
            font-weight: bold;
            color: #1976D2;
            padding: 8px 0;
            border-bottom: 2px solid #1976D2;
        }

        /* Company info bordered box */
        .company-box {
            border: 1px solid #1976D2;
            padding: 10px;
            margin-top: 10px;
        }

        .company-name {
            font-size: 18px;
            font-weight: bold;
            color: #1976D2;
        }

        /* Bill To / Invoice Details sections */
        .info-section {
            margin-top: 10px;
        }

        .info-section .section-header {
            background-color: #e3f2fd;
            padding: 4px 8px;
            font-weight: bold;
            color: #1976D2;
            font-size: 11px;
            border: 1px solid #1976D2;
            border-bottom: none;
        }

        .info-section .section-body {
            border: 1px solid #1976D2;
            padding: 8px;
            min-height: 65px;
        }

        /* Items table - bordered */
        .items-table {
            margin-top: 10px;
            border: 1px solid #1976D2;
        }

        .items-table th {
            background-color: #e3f2fd;
            color: #1976D2;
            padding: 7px 6px;
            font-size: 11px;
            font-weight: bold;
            text-align: center;
            border: 1px solid #1976D2;
        }

        .items-table td {
            padding: 6px;
            border: 1px solid #bbdefb;
            font-size: 11px;
            text-align: center;
        }

        .items-table .total-row td {
            background-color: #e3f2fd;
            font-weight: bold;
            border-top: 2px solid #1976D2;
            color: #1976D2;
        }

        /* Totals section */
        .totals-section {
            margin-top: 10px;
            border: 1px solid #1976D2;
        }

        .totals-section td {
            padding: 5px 10px;
            font-size: 11px;
            border-bottom: 1px solid #bbdefb;
        }

        .totals-section .total-label {
            text-align: right;
            font-weight: bold;
            width: 70%;
            color: #1976D2;
        }

        .totals-section .total-value {
            text-align: right;
            width: 30%;
        }

        .totals-section .grand-total td {
            background-color: #1976D2;
            color: #fff;
            font-weight: bold;
            font-size: 12px;
            border-bottom: none;
        }

        .totals-section .words-row td {
            background-color: #e3f2fd;
            font-size: 10px;
            text-align: left;
            padding: 6px 10px;
        }

        .terms-section {
            margin-top: 12px;
            font-size: 10px;
        }

        .terms-title {
            font-weight: bold;
            color: #1976D2;
            font-size: 11px;
            margin-bottom: 3px;
        }

        .signature-box {
            text-align: center;
            min-width: 180px;
            display: inline-block;
        }

        .signature-line {
            border-top: 1px solid #1976D2;
            margin-top: 5px;
            padding-top: 5px;
            font-weight: bold;
            font-size: 11px;
            color: #1976D2;
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

        {{-- TAX INVOICE TITLE --}}
        <div class="invoice-title">{{ $traslations['tax_invoice'] ?? 'Tax Invoice' }}</div>

        {{-- COMPANY INFO BORDERED BOX --}}
        <div class="company-box">
            <table>
                <tr>
                    <td style="width: 15%; vertical-align: middle;">
                        @if($order->warehouse && $order->warehouse->logo_url)
                            <img src="{{ $order->warehouse->logo_url }}" style="max-width: 90px; max-height: 55px;" />
                        @elseif($company->light_logo_url)
                            <img src="{{ $company->light_logo_url }}" style="max-width: 90px; max-height: 55px;" />
                        @endif
                    </td>
                    <td style="vertical-align: middle;">
                        <div class="company-name">{{ $order->warehouse ? $order->warehouse->name : $company->name }}</div>
                        @if($order->warehouse ? $order->warehouse->address : $company->address)
                            <div style="margin-top: 2px;">{{ $order->warehouse ? $order->warehouse->address : $company->address }}</div>
                        @endif
                        <div>
                            @if($order->warehouse ? $order->warehouse->phone : $company->phone)
                                {{ $traslations['phone'] ?? 'Phone' }}: {{ $order->warehouse ? $order->warehouse->phone : $company->phone }}
                            @endif
                            @if($order->warehouse ? $order->warehouse->email : $company->email)
                                | {{ $order->warehouse ? $order->warehouse->email : $company->email }}
                            @endif
                        </div>
                        @if($order->warehouse && $order->warehouse->gstin)
                            <div class="font-bold">GSTIN: {{ $order->warehouse->gstin }}</div>
                        @endif
                    </td>
                </tr>
            </table>
        </div>

        {{-- BILL TO (left) + INVOICE DETAILS (right) --}}
        <table class="info-section">
            <tr>
                <td style="width: 50%; vertical-align: top; padding-right: 5px;">
                    <div class="section-header">{{ $traslations['bill_to'] ?? 'Bill To' }}</div>
                    <div class="section-body">
                        <div class="font-bold" style="font-size: 12px;">{{ $order->user->name }}</div>
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
                <td style="width: 50%; vertical-align: top; padding-left: 5px;">
                    <div class="section-header">{{ $traslations['invoice_details'] ?? 'Invoice Details' }}</div>
                    <div class="section-body">
                        <div>
                            <span class="font-bold accent">{{ $traslations['invoice'] ?? 'Invoice' }} No:</span>
                            {{ $order->invoice_number }}
                        </div>
                        <div>
                            <span class="font-bold accent">{{ $traslations['order_date'] ?? 'Date' }}:</span>
                            {{ $order->order_date->format($dateTimeFormat) }}
                        </div>
                        @if($order->staffMember)
                            <div>
                                <span class="font-bold accent">{{ $traslations['staff_member'] ?? 'Staff' }}:</span>
                                {{ $order->staffMember->name }}
                            </div>
                        @endif
                        @if($order->warehouse)
                            <div>
                                <span class="font-bold accent">{{ $traslations['warehouse'] ?? 'Warehouse' }}:</span>
                                {{ $order->warehouse->name }}
                            </div>
                        @endif
                    </div>
                </td>
            </tr>
        </table>

        {{-- ITEMS TABLE - BORDERED --}}
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width: 5%;">#</th>
                    <th style="width: 30%;">{{ $traslations['product'] ?? 'Item Name' }}</th>
                    <th style="width: 12%;">HSN/SAC</th>
                    <th style="width: 12%;">{{ $traslations['quantity'] ?? 'Quantity' }}</th>
                    <th style="width: 18%;">{{ $traslations['unit_price'] ?? 'Price/Unit' }} ({{ $company->currency->symbol }})</th>
                    <th style="width: 18%;">{{ $traslations['total'] ?? 'Amount' }} ({{ $company->currency->symbol }})</th>
                </tr>
            </thead>
            <tbody>
                @foreach($order->items as $item)
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td class="text-left" style="padding-left: 8px;">{{ $item->product->name }}</td>
                        <td>{{ $item->hsn_sac_code ?? $item->product->hsn_sac_code ?? '-' }}</td>
                        <td>{{ $item->quantity }} {{ $item->unit->short_name }}</td>
                        <td class="text-right">{{ $company->currency->symbol }}{{ $item->single_unit_price }}</td>
                        <td class="text-right">{{ $company->currency->symbol }}{{ $item->subtotal }}</td>
                    </tr>
                @endforeach

                <tr class="total-row">
                    <td colspan="5" class="text-right">{{ $traslations['total'] ?? 'Total' }}</td>
                    <td class="text-right">{{ $company->currency->symbol }}{{ number_format($order->total, 2) }}</td>
                </tr>
            </tbody>
        </table>

        {{-- TOTALS SECTION --}}
        <table class="totals-section">
            <tr>
                <td class="total-label">{{ $traslations['subtotal'] ?? 'Sub Total' }}:</td>
                <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->subtotal, 2) }}</td>
            </tr>
            @if($order->tax_amount > 0)
                <tr>
                    <td class="total-label">{{ $traslations['tax'] ?? 'Tax' }} ({{ $order->tax_rate }}%):</td>
                    <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->tax_amount, 2) }}</td>
                </tr>
            @endif
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
            <tr class="grand-total">
                <td class="total-label" style="text-align: right;">{{ $traslations['total'] ?? 'Total' }}:</td>
                <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->total, 2) }}</td>
            </tr>
            <tr class="words-row">
                <td colspan="2">
                    <span class="font-bold" style="color: #1976D2;">{{ $traslations['amount_in_words'] ?? 'Invoice Amount in Words' }}:</span>
                    {{ $amountInWords }}
                </td>
            </tr>
            <tr>
                <td class="total-label">{{ $traslations['paid_amount'] ?? 'Received' }}:</td>
                <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->paid_amount, 2) }}</td>
            </tr>
            <tr>
                <td class="total-label">{{ $traslations['due_amount'] ?? 'Balance' }}:</td>
                <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->due_amount, 2) }}</td>
            </tr>
        </table>

        {{-- BANK DETAILS --}}
        @if($order->warehouse && $order->warehouse->bank_details)
            <div class="terms-section" style="margin-top: 12px;">
                <div class="terms-title">{{ $traslations['bank_details'] ?? 'Bank Details' }}:</div>
                <div>{!! nl2br(e($order->warehouse->bank_details)) !!}</div>
            </div>
        @endif

        {{-- TERMS & CONDITIONS + SIGNATORY --}}
        <table style="margin-top: 15px;">
            <tr>
                <td style="width: 55%; vertical-align: top;">
                    @php
                        $terms = $order->terms_condition ?? ($order->warehouse ? $order->warehouse->terms_condition : '');
                    @endphp
                    @if($terms)
                        <div class="terms-section" style="margin-top: 0;">
                            <div class="terms-title">{{ $traslations['terms_conditions'] ?? 'Terms & Conditions' }}:</div>
                            <div>{!! nl2br(e($terms)) !!}</div>
                        </div>
                    @endif
                </td>
                <td style="width: 45%; text-align: right; vertical-align: bottom;">
                    <div class="signature-box">
                        <div class="font-bold accent" style="margin-bottom: 5px;">For {{ $order->warehouse ? $order->warehouse->name : $company->name }}</div>
                        @if($order->warehouse && $order->warehouse->signature)
                            <img src="{{ $order->warehouse->signature_url }}" style="max-width: 150px; max-height: 60px;" />
                            <br>
                        @else
                            <div style="height: 50px;"></div>
                        @endif
                        <div class="signature-line">{{ $traslations['authorized_signatory'] ?? 'Authorized Signatory' }}</div>
                    </div>
                </td>
            </tr>
        </table>

    </div>
</body>

</html>
