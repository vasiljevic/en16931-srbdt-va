<?xml version="1.0" encoding="UTF-8"?>
<!--

    Licensed under European Union Public Licence (EUPL) version 1.2.

-->

<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="UBL-srbdt">
  <rule context="cbc:CustomizationID" flag="fatal">
        <assert 
           test = "starts-with(normalize-space(.), 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022')"
           id="RS-R-001"
           flag="fatal">[RS-R-001]-Identifikator specifikacije (BT-24) treba da počinje sa 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022'</assert>
  </rule>

   <rule context="sbt:SrbDtExt" flag="fatal">
   <assert 
           test = "starts-with(normalize-space(.), 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022#conformant#urn:mfin.gov.rs:srbdtext:2022')"
           id="RS-R-002"
           flag="fatal">[RS-R-002]-Identifikator specifikacije (BT-24) fakture koja koristi ekstenzije treba da počinje sa 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022#conformant#urn:mfin.gov.rs:srbdtext:2022'</assert>
    
  </rule>

  <rule context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" flag="fatal">
    <assert
      test="(self::cbc:InvoiceTypeCode and 
                ( (not(contains(normalize-space(.), ' ')) and 
                   contains(' 380 383 386 ', 
                       concat(' ', normalize-space(.), ' '))))) or 
            (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and 
                    contains(' 381 ', concat(' ', normalize-space(.), ' ')))))" 
      id="RS-R-003" 
      flag="fatal">[RS-R-003]-Tip dokumenta može biti samo 380, 381, 383 ili 386</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
     <assert
       test="not(exists(cbc:TaxPointDate))"
       id="RS-R-004"
       flag="fatal">[RS-R-004]-Faktura ne treba da sadrži element datum poreske obaveze (BT-7), umesto toga treba koristiti šifru datuma poreske obaveze (BT-8)</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
     <assert
       test="exists(/ubl:Invoice/cac:InvoicePeriod/cbc:DescriptionCode | /cn:CreditNote/cac:InvoicePeriod/cbc:DescriptionCode)"
       id="RS-R-005"
       flag="fatal">[RS-R-005]-Faktura treba da sadrži šifru datuma poreske obaveze (BT-8)</assert>
  </rule>

  <rule context="/ubl:Invoice/cac:InvoicePeriod/cbc:DescriptionCode | /cn:CreditNote/cac:InvoicePeriod/cbc:DescriptionCode">
    <assert
       test="(not(contains(normalize-space(.), ' ')) and 
                   contains(' 35 432 3 ', concat(' ', normalize-space(.), ' ')))"
       id="RS-R-006"
       flag="fatal">[RS-R-006]-Šifra datuma poreske obaveze može biti samo 35 (prema datumu prometa), 432 (prema datumu plaćanja) ili 3 (prema datumu izdavanja fakture)</assert>
  </rule>

  <rule context="cac:BillingReference">
    <assert 
       test="exists(cac:InvoiceDocumentReference/cbc:IssueDate)" 
       flag="fatal" 
       id="RS-R-007">[RS-R-007]-Svaka referenca na prethodni dokument (BG-3) treba da sadrži datum izdavanja prethodnoe fakture (BT-26).</assert>
  </rule>

</pattern>