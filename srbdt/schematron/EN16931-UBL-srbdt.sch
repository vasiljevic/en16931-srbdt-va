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

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert 
      test="not (cac:InvoicePeriod/cbc:DescriptionCode = '432') or exists(/ubl:Invoice/cbc:DueDate | /cn:CreditNote/cac:PaymentMeans/cbc:PaymentDueDate)"
      flag="fatal"
      id="RS-R-008">[RS-R-008]-Kada šifra datuma poreske obaveze (BT-8) određuje da poreska obaveza nastaje prema datumu plaćanja (šifra 432) tada treba da je naveden datum dospeća plaćanja (BT-9)</assert>
    <assert
      test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID)"
      flag="fatal"
      id="RS-R-009">[RS-R-008]-Faktura treba da sadrži PIB prodavca (BT-31)</assert>
    <assert 
      test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) != 'VAT']/cbc:CompanyID)"
      flag="fatal"
      id="RS-R-010">[RS-R-010]-Faktura treba da sadrži identifikator registracije poreza na strani prodavca (BT-32)</assert>
  </rule>
  <rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme[normalize-space(upper-case(cbc:ID)) != 'VAT']">
      <assert
        test="upper-case(normalize-space(cbc:ID)) = 'RS-VAT-STATUS'"
        flag="fatal"
        id="RS-SR-001">[RS-SR-001]-Kod identifikatora registracije poreza na strani prodavca treba da se koristi PartyTaxScheme ID sa vrednošću RS-VAT-STATUS</assert>
  </rule>

  <rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID">
      <assert
        test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and
              (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))"
        flag="fatal"
        id="RS-R-011">[RS-R-011]-PIB prodavca (BT-31) treba da ima prefiks RS i nakon toga 9 ili 13 cifara</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingSupplierParty/cac:Party/cbc:EndpointID)"
      flag="fatal"
      id="RS-R-012">[RS-R-012]-Faktura treba da sadrži elektronsku adresu prodavca (BT-34)</assert>
  </rule>

  <rule context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID">
    <assert
      test="normalize-space(@schemeID) = '9948'"
      flag="fatal"
      id="RS-R-13">[RS-R-013]-Elektronska adresa prodavca (BT-34) treba da ima identifikator šeme '9948'</assert>
  </rule>

  <rule context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID">
    <assert 
      test="concat('RS',normalize-space(.)) = 
             normalize-space(upper-case(../cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID))"
      flag="fatal"
      id="RS-R-14">[RS-R-014]-Elektronska adresa prodavca (BT-34) treba da sadrži PIB prodavca (BT-31) bez prefiksa 'RS'</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName)"
      flag="fatal"
      id="RS-R-015">[RS-R-015]-Faktura treba da sadrži mesto prodavca (BT-37)</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID)"
      flag="fatal"
      id="RS-R-016">[RS-R-016]-Faktura treba da sadrži matični broj kupca (BT-47)</assert>
  </rule>


  <rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
    <assert
      test="not(exists(@schemeID))"
      flag="fatal"
      id="RS-R-17">[RS-R-017]-Matični broj kupca (BT-47) ne treba da ima identifikator šeme</assert>
    <assert
        test="(matches(normalize-space(.),'^[0-9]+$')) and
              (contains(' 8 13 ', concat(' ', string-length(normalize-space(.)),' ')))"
        flag="fatal"
        id="RS-R-018">[RS-R-018]-Matični broj kupca (BT-47)  treba da ima 8 ili 13 cifara</assert> 
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)"
      flag="fatal"
      id="RS-R-019">[RS-R-019]-Faktura treba da sadrži PIB kupca (BT-48)</assert>
  </rule>

  <rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID">
      <assert
        test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and
              (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))"
        flag="fatal"
        id="RS-R-020">[RS-R-020]-PIB kupca (BT-48) treba da ima prefiks RS i nakon toga 9 ili 13 cifara</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingCustomerParty/cac:Party/cbc:EndpointID)"
      flag="fatal"
      id="RS-R-021">[RS-R-021]-Faktura treba da sadrži elektronsku adresu kupca (BT-49)</assert>
  </rule>

  <rule context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
    <assert
      test="normalize-space(@schemeID) = '9948'"
      flag="fatal"
      id="RS-R-22">[RS-R-022]-Elektronska adresa kupca (BT-49) treba da ima identifikator šeme '9948'</assert>
  </rule>

  <rule context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
    <assert 
      test="concat('RS',normalize-space(.)) = 
             normalize-space(upper-case(../cac:PartyTaxScheme/cbc:CompanyID))"
      flag="fatal"
      id="RS-R-23">[RS-R-023]-Elektronska adresa kupca (BT-49) treba da sadrži PIB kupca (BT-48) bez prefiksa 'RS'</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName)"
      flag="fatal"
      id="RS-R-024">[RS-R-024]-Faktura treba da sadrži mesto kupca (BT-52)</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert
      test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone)"
      flag="fatal"
      id="RS-R-025">[RS-R-025]-Faktura treba da sadrži poštanski broj kupca (BT-52)</assert>
  </rule>

  <rule context="/ubl:Invoice/cac:PayeeParty | /cn:CreditNote/cac:PayeeParty" flag="fatal">
    <assert
       test="count(cac:PartyLegalEntity/cbc:CompanyID) = 1"
       flag="fatal"
       id="RS-R-026">[RS-R-026]-Primalac plaćanja (BG-10) treba da ima tačno jedan matični broj primaoca plaćanja (BT-61)</assert>
  </rule>

  <rule context="cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID" flag="fatal">
     <assert
        test="(matches(normalize-space(.),'^[0-9]+$')) and
              (contains(' 8 13 ', concat(' ', string-length(normalize-space(.)),' ')))"
        flag="fatal"
        id="RS-R-27">[RS-R-027]-Matični broj primaoca plaćanja (BT-61) treba da ima 8 ili 13 cifara</assert> 
  </rule>

  <rule context="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" flag="fatal">
    <assert
      test="exists(cac:PartyTaxScheme/cbc:CompanyID)"
      flag="fatal"
      id="RS-R-028">[RS-R-28]-Poreski punomoćnik prodavca (BG-11) treba da sadrži PIB poreskog punomoćnika (BT-63)</assert>
  </rule>

  <rule context="cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID">
      <assert
        test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and
              (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))"
        flag="fatal"
        id="RS-R-029">[RS-R-029]-PIB poreskog punomoćnika prodavca (BT-48) treba da ima prefiks RS i nakon toga 9 ili 13 cifara</assert>
  </rule>

  <rule context="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" flag="fatal">
    <assert
      test="exists(cac:PostalAddress/cbc:CityName)"
      flag="fatal"
      id="RS-R-030">[RS-R-030]-Poreski punomoćnik prodavca (BG-11) treba da sadrži mesto poreskog punomoćnika (BT-66)</assert>
  </rule>

  <rule context="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" flag="fatal">
    <assert
      test="exists(cac:PostalAddress/cbc:PostalZone)"
      flag="fatal"
      id="RS-R-031">[RS-R-031]-Poreski punomoćnik prodavca (BG-11) treba da sadrži poštanski broj poreskog punomoćnika (BT-67)</assert>
  </rule>

  <rule context="/ubl:Invoice | /cn:CreditNote" flag="fatal">
    <assert 
      test="not(cac:InvoicePeriod/cbc:DescriptionCode = '35') or exists(cac:Delivery/cbc:ActualDeliveryDate)"
      flag="fatal"
      id="RS-R-032">[RS-R-032]-Kada šifra datuma poreske obaveze (BT-8) određuje da poreska obaveza nastaje prema datumu prometa (šifra 35) tada treba da je naveden datum prometa (BT-72)</assert>
  </rule>

    <rule context="cac:TaxCategory/cbc:ID" flag="fatal">
    <assert
      test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" 
      id="RS-BR-CL-17" 
      flag="fatal">[BR-CL-17]-Šifra kategorije PDV-a treba da bude jedna od S, AE, Z, E, O, R, OE, SS ili N</assert>
  </rule>
  
  <rule context="cac:ClassifiedTaxCategory/cbc:ID" flag="fatal">
    <assert
      test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" 
      id="RS-BR-CL-18" 
      flag="fatal">[BR-CL-18]-Šifra kategorije PDV-a treba da bude jedna od S, AE, Z, E, O, R, OE, SS ili N</assert>
  </rule>

  <rule context="sbt:SrbDtExt/sbt:ReducedTotals" flag="fatal">
    <assert 
      test="(exists(/ubl:Invoice) and (xs:decimal(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount) = 
              xs:decimal(/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount) - xs:decimal(/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PrepaidAmount))) or
            (exists(/cn:CreditNote) and (xs:decimal(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount) = 
              xs:decimal(/cn:CreditNote/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount) - xs:decimal(/cn:CreditNote/cac:LegalMonetaryTotal/cbc:PrepaidAmount)))"
      id="RS-ER-001"
      flag="fatal">[RS-ER-001]-Umanjen ukupan iznos bez PDV-a (BT-Е10) treba da bude jednak razlici ukupnog iznosa sa PDV-om (BT-112) i plaćenog iznosa (BT-113)</assert>
  </rule>
</pattern>