<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>{{ $order->invoice_number }}</title>

    <style>
        @page {
            margin: 12px;
            size: A4 landscape;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: DejaVu Sans, sans-serif;
            font-size: 10px;
            color: #333;
            line-height: 1.3;
            background: #fff;
        }

        .invoice-wrapper {
            max-width: 1100px;
            margin: 0 auto;
            padding: 8px;
        }

        .accent { color: #2196F3; }
        .accent-bg { background-color: #2196F3; color: #fff; }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        .text-left { text-align: left; }
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .font-bold { font-weight: bold; }
        .font-sm { font-size: 9px; }

        .mt-5 { margin-top: 5px; }
        .mt-8 { margin-top: 8px; }
        .mt-10 { margin-top: 10px; }
        .mb-5 { margin-bottom: 5px; }

        /* Tax Invoice top center */
        .invoice-title {
            text-align: center;
            font-size: 16px;
            font-weight: bold;
            color: #2196F3;
            padding: 6px 0;
            border-bottom: 2px solid #2196F3;
            margin-bottom: 8px;
        }

        /* Header row */
        .header-section td {
            padding: 5px 0;
        }

        .company-name {
            font-size: 16px;
            font-weight: bold;
            color: #2196F3;
        }

        /* Bill To */
        .bill-to-label {
            font-weight: bold;
            color: #2196F3;
            font-size: 11px;
            border-bottom: 1px solid #bbdefb;
            padding-bottom: 2px;
            margin-bottom: 4px;
        }

        /* Items table */
        .items-table {
            margin-top: 8px;
            border: 1px solid #bbdefb;
        }

        .items-table th {
            background-color: #2196F3;
            color: #fff;
            padding: 5px 4px;
            font-size: 10px;
            text-align: center;
            border-right: 1px solid rgba(255,255,255,0.2);
        }

        .items-table th:last-child {
            border-right: none;
        }

        .items-table td {
            padding: 4px 5px;
            border-bottom: 1px solid #e3f2fd;
            border-right: 1px solid #e3f2fd;
            font-size: 10px;
            text-align: center;
        }

        .items-table td:last-child {
            border-right: none;
        }

        .items-table .total-row td {
            background-color: #e3f2fd;
            font-weight: bold;
            border-top: 2px solid #2196F3;
        }

        /* Combined total + words row */
        .combined-row {
            background-color: #e3f2fd;
            border: 1px solid #bbdefb;
            border-top: none;
            padding: 6px 10px;
            font-size: 10px;
        }

        /* Received + Balance row */
        .balance-row {
            border: 1px solid #bbdefb;
            border-top: none;
        }

        .balance-row td {
            padding: 5px 10px;
            font-size: 10px;
        }

        .balance-row .label-cell {
            font-weight: bold;
            width: 15%;
        }

        .balance-row .value-cell {
            width: 35%;
        }

        .terms-section {
            margin-top: 8px;
            font-size: 9px;
        }

        .terms-title {
            font-weight: bold;
            color: #2196F3;
            font-size: 10px;
            margin-bottom: 2px;
        }

        .signature-box {
            text-align: center;
            min-width: 180px;
            display: inline-block;
        }

        .signature-line {
            border-top: 1px solid #2196F3;
            margin-top: 3px;
            padding-top: 3px;
            font-weight: bold;
            font-size: 10px;
            color: #2196F3;
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

        {{-- TAX INVOICE TITLE AT TOP --}}
        <div class="invoice-title">{{ $traslations['tax_invoice'] ?? 'Tax Invoice' }}</div>

        {{-- HEADER: Logo + Company left, Invoice No/Date right --}}
        <table class="header-section">
            <tr>
                <td style="width: 10%; vertical-align: middle;">
                    @if($company->light_logo_url)
                        <img src="{{ $company->light_logo_url }}" style="max-width: 80px; max-height: 45px;" />
                    @endif
                </td>
                <td style="width: 45%; vertical-align: middle;">
                    <div class="company-name">{{ $company->name }}</div>
                    @if($company->address)
                        <div class="font-sm">{{ $company->address }}</div>
                    @endif
                    <div class="font-sm">
                        @if($company->phone)
                            {{ $traslations['phone'] ?? 'Phone' }}: {{ $company->phone }}
                        @endif
                        @if($company->email)
                            | {{ $company->email }}
                        @endif
                    </div>
                    @if($company->gstin)
                        <div class="font-sm font-bold">GSTIN: {{ $company->gstin }}</div>
                    @endif
                </td>
                <td style="width: 45%; text-align: right; vertical-align: middle;">
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
                </td>
            </tr>
        </table>

        {{-- BILL TO --}}
        <div class="mt-5">
            <div class="bill-to-label">{{ $traslations['bill_to'] ?? 'Bill To' }}:</div>
            <table>
                <tr>
                    <td style="width: 50%;">
                        <span class="font-bold">{{ $order->user->name }}</span>
                        @if($order->user->address)
                            <span class="font-sm"> | {{ $order->user->address }}</span>
                        @endif
                    </td>
                    <td style="width: 50%;">
                        @if($order->user->phone)
                            <span class="font-bold">{{ $traslations['contact_no'] ?? 'Contact No' }}:</span> {{ $order->user->phone }}
                        @endif
                        @if($order->user->email)
                            | {{ $order->user->email }}
                        @endif
                        @if($order->user->tax_number)
                            | <span class="font-bold">GSTIN:</span> {{ $order->user->tax_number }}
                        @endif
                    </td>
                </tr>
            </table>
        </div>

        {{-- ITEMS TABLE --}}
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width: 4%;">#</th>
                    <th style="width: 30%;">{{ $traslations['product'] ?? 'Item Name' }}</th>
                    <th style="width: 10%;">HSN/SAC</th>
                    <th style="width: 10%;">{{ $traslations['quantity'] ?? 'Quantity' }}</th>
                    <th style="width: 15%;">{{ $traslations['unit_price'] ?? 'Price/Unit' }} ({{ $company->currency->symbol }})</th>
                    <th style="width: 15%;">{{ $traslations['total'] ?? 'Amount' }} ({{ $company->currency->symbol }})</th>
                </tr>
            </thead>
            <tbody>
                @foreach($order->items as $item)
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td class="text-left" style="padding-left: 6px;">{{ $item->product->name }}</td>
                        <td>{{ $item->hsn_sac_code ?? $item->product->hsn_sac_code ?? '-' }}</td>
                        <td>{{ $item->quantity }} {{ $item->unit->short_name }}</td>
                        <td class="text-right">{{ $company->currency->symbol }}{{ $item->single_unit_price }}</td>
                        <td class="text-right">{{ $company->currency->symbol }}{{ $item->subtotal }}</td>
                    </tr>
                @endforeach

                <tr class="total-row">
                    <td colspan="5" class="text-right font-bold">{{ $traslations['total'] ?? 'Total' }}</td>
                    <td class="text-right">{{ $company->currency->symbol }}{{ number_format($order->total, 2) }}</td>
                </tr>
            </tbody>
        </table>

        {{-- COMBINED ROW: Total amount + amount in words --}}
        <div class="combined-row">
            <table>
                <tr>
                    <td style="width: 20%;" class="font-bold">
                        {{ $traslations['total'] ?? 'Total' }}: {{ $company->currency->symbol }}{{ number_format($order->total, 2) }}
                    </td>
                    <td style="width: 80%;">
                        <span class="font-bold accent">{{ $traslations['amount_in_words'] ?? 'Amount in Words' }}:</span>
                        {{ $amountInWords }}
                    </td>
                </tr>
            </table>
        </div>

        {{-- RECEIVED + BALANCE ROW --}}
        <table class="balance-row">
            <tr>
                <td class="label-cell accent">{{ $traslations['paid_amount'] ?? 'Received' }}:</td>
                <td class="value-cell">{{ $company->currency->symbol }}{{ number_format($order->paid_amount, 2) }}</td>
                <td class="label-cell accent">{{ $traslations['due_amount'] ?? 'Balance' }}:</td>
                <td class="value-cell">{{ $company->currency->symbol }}{{ number_format($order->due_amount, 2) }}</td>
            </tr>
        </table>

        {{-- TERMS & CONDITIONS + SIGNATORY --}}
        <table style="margin-top: 12px;">
            <tr>
                <td style="width: 60%; vertical-align: top;">
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
                <td style="width: 40%; text-align: right; vertical-align: bottom;">
                    <div class="signature-box">
                        <div class="font-bold accent" style="margin-bottom: 3px;">For {{ $company->name }}</div>
                        @if($order->warehouse && $order->warehouse->signature)
                            <img src="{{ $order->warehouse->signature_url }}" style="max-width: 120px; max-height: 45px;" />
                            <br>
                        @else
                            <div style="height: 35px;"></div>
                        @endif
                        <div class="signature-line">{{ $traslations['authorized_signatory'] ?? 'Authorized Signatory' }}</div>
                    </div>
                </td>
            </tr>
        </table>

    </div>
</body>

</html>
