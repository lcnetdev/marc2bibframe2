
[![CircleCI](https://circleci.com/gh/lcnetdev/marc2bibframe2/tree/master.svg?style=svg)](https://circleci.com/gh/lcnetdev/marc2bibframe2)

# marc2bibframe2

XSLT-based conversion from
[MARCXML](http://www.loc.gov/standards/marcxml/) to
[BIBFRAME 2.0](http://www.loc.gov/bibframe/)

* [Introduction](#introduction)
* [Using the converter](#using-the-converter)
    * [Converter parameters](#converter-parameters)
    * [Converter configuration](#converter-configuration)
* [Converter design](#converter-design)
* [Testing](#testing)
* [Active record conversion](#active-record-conversion)
* [Metaproxy integration](#metaproxy-integration)
* [Known issues](#known-issues)
* [Repository contents](#repository-contents)
* [Dependencies](#dependencies)
* [License](#license)

## Introduction
This repository contains an XSLT 1.0 application for converting MARCXML
records to [RDF/XML](https://www.w3.org/TR/rdf-syntax-grammar/), using
the BIBFRAME 2.0 and [MADSRDF](http://www.loc.gov/standards/mads/rdf/)
ontologies. The expected input is a MARCXML record or collection, and
the output is an XML document expressing the data as a set of RDF
triples in the [striped](http://www.w3.org/2001/10/stripes/) RDF/XML
syntax. In addition, there is a sample configuration for the
[Metaproxy](http://www.indexdata.com/metaproxy/) search gateway server
from [Index Data](http://www.indexdata.com), showing the integration
of the application with Metaproxy to provide both a "static"
conversion of MARC records and an "active" conversion that attempts to
resolve identifiers for configured entities.

The specification for the conversion has been published by the Library
of Congress at http://www.loc.gov/bibframe/mtbf/.

## Using the converter
In the simplest case, you can invoke an XSLT processor with the
main stylesheet (`xsl/marc2bibframe2.xsl`) as the first argument, and
an XML file containing MARCXML as the second:

    xsltproc xsl/marc2bibframe2.xsl test/data/marc.xml

### Preprocessing (new as of Oct 2023)
An option preprocessing step will attempt to split individual MARC 
records into multiple MARC records with the additional MARC records
representing different Instances of the same Work in the original or 
source MARC record.  It takes a MARC/XML record as input and will 
output a marc:collection of one or more MARC records.  See the 
Preprocess 0 document in the [spec/](spec/) directory.  Like the main
stylesheet, it can be invoked:

    xsltproc xsl/ConvSpec-Preprocess0-Splitting.xsl test/data/marc.xml

More information about this process was presented in July 2023.  That 
presentation can be [viewed in full](https://www.youtube.com/watch?v=9i3y23XiNQE)
or the [slides downloaded](<https://www.loc.gov/bibframe/pdf/LD4-Breaking%20News-Splitting MARC records-20230712.pdf>).

### Converter parameters
The converter supports several optional parameters:
- `baseuri` - the URI stem for generated entities. Default is
  `http://example.org/`, which will result in minting URIs like
  `http://example.org/<record ID>#Work`

- `idfield` - the field of the MARC record that contains the record
  ID, used in minting URIs as above. Default is `001`. If the
  `idfield` refers to a MARC data field rather than a MARC control
  field, the subfield can also be indicated - e.g. `035a` (the default
  subfield is `a`). *Note* - the converter will attempt to URL-encode
  the resulting record ID, substituting `%3F` (the `?` character) for
  anything outside the ASCII range.

- `idsource` - a URI used to identify the source of the Local
  identifier derived from the `idfield` - e.g.,
  `http://id.loc.gov/vocabulary/organizations/dlc`. This will be empty
  by default, resulting in no source property being defined.

- `localfields` - if true, apply special local processing for Library
of Congress records. This includes:
  - Process 859 fields the same as 856 fields

- `pGenerationDatestamp` - a value to be used as the datestamp for the
  bf:generationProcess property for the Work AdminMetadata. Defaults
  to the current date/time if the EXSLT `date:date-time()` function is
  available, otherwise defaults to an empty string.

- `serialization` - the RDF serialization to be used for
  output. Currently only `rdfxml` is supported (the default).

Different XSLT processors have different syntaxes for passing
parameters. For xsltproc, the syntax is:

    xsltproc --stringparam baseuri http://mylibrary.org/ --stringparam idsource http://id.loc.gov/vocabulary/organizations/dlc xsl/marc2bibframe2.xsl test/data/marc.xml

For [Metaproxy integration](#metaproxy-integration), the converter
parameters can be passed to the stylesheets using the `<param>`
element in the YAZ configuration:

```xml
<xslt stylesheet="xsl/marc2bibframe2.xsl">
  <param name="baseuri" value="http://mylibrary.org/"/>
</xslt>
```

### Converter configuration
Some elements of the conversion can be configured using XML files in
the [xsl/conf](xsl/conf) directory. This includes, e.g., language
mappings for elements generated by 880 tags, and subject thesaurus
mappings for MADSRDF elements generated by 6XX tags.

## Converter design
The main stylesheet of the XSLT converter application,
[xsl/marc2bibframe.xsl](xsl/marc2bibframe.xsl), uses push processing
to process the fields of each MARC record and build the two main
elements it generates, a `bf:Work` and a `bf:Instance`. In addition,
the fields are pushed through to generate a `bflc:adminMetaData`
property of the `bf:Work` and to generate `bf:hasItem` properties of
the `bf:Instance`.

Elements in the resulting RDF/XML document that are not blank nodes or
nodes with statically determined URIs are given newly minted URIs
constructed from the stem of the baseuri parameter (default
`http://example.org/`), the record ID of the MARC record (by default
the value of the 001 field), and a
[hash URI](https://www.w3.org/TR/cooluris/#hashuri) for the new
element. For elements that are not the main `bf:Work` or `bf:Instance`
element generated by the record, the hash URI is constructed from the
element class, the field number, and the position of the field in the
MARC record, e.g.:

    http://example.org/13600108#Agent100-12

The templates that match the MARC fields are contained in included
stylesheets from the main stylesheet, along with some utility
templates in the `utils.xsl` stylesheet and templates for matching
control subfields in the `ConvSpec-ControlSubfields.xsl`
stylesheet. Configuration information is read into variables using the
`document()` function.

As much as possible, templates representing each specification
document in the [specifications](http://www.loc.gov/bibframe/mtbf/)
are contained in a stylesheet with the same name, for easier
maintenance.

## Testing
Each of the specification documents in the
[specifications](http://www.loc.gov/bibframe/mtbf/) is represented in
a corresponding test suite in the [test](test) directory, with test
data in the [test/data](test/data) directory.

The tests are written for the [XSpec](https://github.com/xspec/xspec)
testing framework, a behavior driven development testing framework for
XSLT and XQuery. To run the tests, you must install the Saxon XSLT and
XQuery processor as well as XSpec. Installation instructions are
available on the [XSpec wiki](https://github.com/xspec/xspec/wiki).

Once you have XSpec installed, you can run the entire test suite with
the command (for Mac OS or Linux):

    xspec.sh test/marc2bibframe2.xspec

Test reports will be output in the test/xspec directory.

### Testing for LoC-specific conversion

There are a few conversion behaviors that are specific to the Library
of Congress. For example, the Library of Congress uses a
locally-defined 859 field as an analogue to the standard 856. To test
LoC-specific conversions, run only the ConvSpec-DLC.xspec test suite:

    xspec.sh test/ConvSpec-DLC.xspec

## Active record conversion

Active conversion of records - resolving URIs for elements of the
RDF/XML output from authoritative sources, like the Library of Congress
Name Authority File, is achieved through a retrieval tool conversion
in the [YAZ toolkit](http://www.indexdata.com/yaz).

The retrieval tool in YAZ is driven by an XML configuration,
documented in the
[YAZ User's Guide and Reference](http://www.indexdata.com/yaz/doc/tools.retrieval.html).
The YAZ conversion for RDF/XML is called `rdf-lookup`, and a simple
configuration looks like this:

```xml
<backend syntax="xml" name="rdf-lookup">
  <xslt stylesheet="xsl/marc2bibframe2.xsl"/>
  <rdf-lookup debug="1">
    <namespace prefix="bf" href="http://id.loc.gov/ontologies/bibframe/" />
    <namespace prefix="bflc" href="http://id.loc.gov/ontologies/bflc/"/>
    <lookup xpath="//bf:contribution/bf:Contribution/bf:agent/bf:Agent">
      <key field="bflc:name00MatchKey"/>
      <key field="bflc:name01MatchKey"/>
      <key field="bflc:name11MatchKey"/>
      <server url="http://id.loc.gov/authorities/names/label/%s" method="HEAD"/>
    </lookup>
  </rdf-lookup>
</backend>
```

From the YAZ User's Guide:
>The debug="1" attribute tells the filter to add XML comments to the key
>nodes that indicate what lookup it tried to do, how it went, and how
>long it took.  The namespace prefix bf: is defined in the namespace
>tags. These namespaces are used in the xpath expressions in the
>lookup sections.  The lookup tag specifies one tag to be looked
>up. The xpath attribute defines which node to modify. It may make use
>of the namespace definitions above.  The server tag gives the URL to
>be used for the lookup. A %s in the string will get replaced by the
>key value. If there is no server tag, the one from the preceding
>lookup section is used, and if there is no previous section, the
>id.loc.gov address is used as a default. The default is to make a GET
>request, this example uses HEAD.

A full sample configuration is available in this directory as
[record-conv.xml](record-conv.xml). Using this configuration, you
could perform an active conversion of a MARCXML file using the
[yaz-record-conv](http://www.indexdata.com/yaz/doc/yaz-record-iconv.html)
utility like so:

    yaz-record-conv record-conv.xml test/data/marc.xml

The rdf-lookup conversion support was first introduced in YAZ v5.19.0.
YAZ 5.20.0 provided a significant performance improvement for HEAD
requests, so using that version or higher is highly recommended.

## Metaproxy integration
Both the static and active conversions can be easily integrated into
Index Data's [Metaproxy](http://www.indexdata.com/metaproxy)
metasearch gateway software as a record output format. A sample filter
configuration is in the [metaproxy](metaproxy) directory. With this
filter configuration, an SRU request to the server like
`http://metaproxy.mylibrary.org/?version=1.1&operation=searchRetrieve&query=rec.id%3D13600108&recordSchema=bibframe2&startRecord=1&maximumRecords=1`
would retrieve and display the requested record converted into
BIBFRAME triples in RDF/XML format. The
[install-filters.sh](metaproxy/install-filters.sh) script in that
directory would deploy the filters into a running Metaproxy
configuration.

In addition, we have provided a Vagrantfile and Ansible playbook to
build a local Metaproxy VM using VirtualBox for testing, available in
the [deploy](deploy) directory.

## Known issues
- Dealing with punctuation embedded in cataloged bibliographic
  records is an inexact science. The specifications address this issue
  very minimally. Some attempt has been made to do a reasonable amount
  of punctuation handling. In general, for rdfs:label elements,
  punctuation is left in place as it is found in the source
  record. For other data elements, an attempt is made to strip end
  punctuation where appropriate.

- The handling of alternative scripts through the MARC subfield 6 and
  data field 880 is done by processing 880 tags as if they were the
  source tag - so a data field like:

  ```xml
  <datafield ind1="0" ind2=" " tag="880">
    <subfield code="6">130-01/(3</subfield>
    <subfield code="a">ملحمة دانيال</subfield>
  </datafield>
  ```

  Is processed as though it was a MARC data field 130. No attempt is
  made to link the subfield 6 of the source tag with the appropriate 880.

- `bf:hasItem` properties and `bf:Item` elements can be created by
  several MARC data fields. It is not always clear whether the
  data fields in the record refer to the same item, or to different
  items held by different institutions. This will likely result in the
  creation of separate `bf:Item` elements that need to be collapsed.

## Repository contents

* dataset - sample records for exercising conversion
* metaproxy - sample [Metaproxy](http://www.indexdata.com/metaproxy/)
  configuration for static and active conversion
* spec - the current specifications of the conversion. These are
  mostly published on the
  [BIBFRAME website|http://www.loc.gov/bibframe/mtbf/], but the
  versions in the conversion may be ahead of the published versions.
* test - Unit tests for the [XSpec](https://github.com/xspec/xspec)
  testing framework, and test data
* xsl - XSLT 1.0 stylesheets for transformation, configuration in xsl/conf

## Dependencies

* [Ansible](https://www.ansible.com) /
  [Vagrant](https://www.vagrantup.com) /
  [VirtualBox](https://www.virtualbox.org) for building a local VM
  Metaproxy server
* [Metaproxy](http://www.indexdata.com/metaproxy) for Metaproxy
  integration
* [XSpec](https://github.com/xspec/xspec) for unit tests
* [YAZ](http://www.indexdata.com/yaz) v5.20.0 or higher for active conversion

## License
As a work of the United States government, this project is in the
public domain within the United States.

Additionally, we waive copyright and related rights in the work
worldwide through the CC0 1.0 Universal public domain dedication. 

[Legal Code (read the full text)](https://creativecommons.org/publicdomain/zero/1.0/legalcode).

You can copy, modify, distribute and perform the work, even for commercial
purposes, all without asking permission.
