<?php

namespace App\Helpers;

class NumberToWords
{
    private static $ones = [
        '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
        'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
        'Seventeen', 'Eighteen', 'Nineteen'
    ];

    private static $tens = [
        '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
    ];

    public static function convert($number, $currency = 'Rupees', $subCurrency = 'Paise')
    {
        if ($number == 0) {
            return 'Zero ' . $currency . ' only';
        }

        $number = round($number, 2);
        $wholeNumber = intval($number);
        $decimal = round(($number - $wholeNumber) * 100);

        $words = self::convertToIndianSystem($wholeNumber);
        $result = $words . ' ' . $currency;

        if ($decimal > 0) {
            $decimalWords = self::convertToIndianSystem($decimal);
            $result .= ' and ' . $decimalWords . ' ' . $subCurrency;
        }

        return $result . ' only';
    }

    private static function convertToIndianSystem($number)
    {
        if ($number == 0) return '';

        $result = '';

        // Crore (10,000,000)
        if ($number >= 10000000) {
            $result .= self::convertToIndianSystem(intval($number / 10000000)) . ' Crore ';
            $number %= 10000000;
        }

        // Lakh (100,000)
        if ($number >= 100000) {
            $result .= self::convertToIndianSystem(intval($number / 100000)) . ' Lakh ';
            $number %= 100000;
        }

        // Thousand
        if ($number >= 1000) {
            $result .= self::convertToIndianSystem(intval($number / 1000)) . ' Thousand ';
            $number %= 1000;
        }

        // Hundred
        if ($number >= 100) {
            $result .= self::$ones[intval($number / 100)] . ' Hundred ';
            $number %= 100;
        }

        // Tens and ones
        if ($number >= 20) {
            $result .= self::$tens[intval($number / 10)] . ' ';
            $number %= 10;
        }

        if ($number > 0) {
            $result .= self::$ones[$number] . ' ';
        }

        return trim($result);
    }
}
