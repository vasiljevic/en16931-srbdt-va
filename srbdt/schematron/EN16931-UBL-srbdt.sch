<?xml version="1.0" encoding="UTF-8"?>
<!--

    Licensed under European Union Public Licence (EUPL) version 1.2.

-->

<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="UBL-srbdt">
  <rule context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" flag="fatal">
    <assert
      test="(self::cbc:InvoiceTypeCode and 
                ( (not(contains(normalize-space(.), ' ')) and 
                   contains(' 380 383 386 ', 
                       concat(' ', normalize-space(.), ' '))))) or 
            (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and 
                    contains(' 381 ', concat(' ', normalize-space(.), ' ')))))" 
      id="RS-R-002" 
      flag="fatal">[RS-R-002]- Tip dokumenta može biti samo 380, 381, 383 ili 386</assert>
  </rule>
</pattern>