# marc2bibframe2 release notes

## v2.4.0

Conversion updates based on specifications v2.4. See the Library of Congress’s [BIBFRAME site](https://www.loc.gov/bibframe/) for more details. Specifications are included in the distribution in the [spec](spec/) directory. Changes of note:

* Placement of title non-filing indicator values in new bflc property "nonSortNum."
* All bytes from the MARC 007 field are now mapped to the BIBFRAME Instance.
* MARC 856 fields will create BIBFRAME Instances instead of BIBFRAME Items.
* Splitting of a single MARC record with multiple 007, 300 and 856 fields into multiple records - one for each iteration of the resource – which creates multiple Instances linked to a Work. The split occurs as a preprocessing step documented in the new "Preprocess 0" spec. 
* The Instances created via the splitting process are given the rdf:type "bflc:SecondaryInstance."

See the [NEWS](NEWS) file and the [updated specifications](spec/) for full details of changes. Changes from v2.3.0 in the specifications are marked in red.


## v2.3.0

Conversion updates based on specifications v2.3. See the Library of Congress’s [BIBFRAME site](https://www.loc.gov/bibframe/) for more details. Specifications are included in the distribution in the [spec](spec/) directory. Changes of note:

* Stop generating Item/shelfMark from 050.
* 051s use same Classification pattern as 050s.
* Refactor Item generation to be more targetted and group better.
* 561, 563, and 581 to Instance unless $5, in which case continues to go to Item.
* Incorporate new 'use by agency' statuses for Classification resources from 050, 055, 060, 070. 

See the [NEWS](NEWS) file and the [updated specifications](spec/) for full details of changes. Changes from v2.2.0 in the specifications are marked in red.

## v2.2.1

Patch release.

* Finesse how 1XX $t is excised when converting to 240.

## v2.2.0

Conversion updates based on specifications v2.2. See the Library of Congress’s [BIBFRAME site](https://www.loc.gov/bibframe/) for more details. Specifications are included in the distribution in the [spec](spec/) directory. Changes of note:

* Removed *MatchKey properties.
* Removed specific *MarcKey properties.
* Introduced generic bflc:marcKey property.
* Removed titleSortKey and replaed with nonSortNum property.
* Refactored handling of FAST headings to convert identifiers to URIs.

See the [NEWS](NEWS) file and the [updated specifications](spec/) for full details of changes. Changes from v2.1.0 in the specifications are marked in red.

## v2.1.0

Conversion updates based on specifications v2.1. See the Library of Congress’s [BIBFRAME site](https://www.loc.gov/bibframe/) for more details. Specifications are included in the distribution in the [spec](spec/) directory. Changes of note:

* Model language notes as notes, not languages.
* Add lang tag to literal properties for 242.
* Amend 490 handling, making all Uncontrolled, remove Hub type.
* Remove ending period from subjects from 65X fields.
* Generate bflc:publicationStatement, bflc:productionStatement, etc.

## v2.0.2

Patch release to address https://github.com/lcnetdev/marc2bibframe2/issues/224 

## v2.0.0

Conversion updates based on specifications v2.0. See the Library of Congress’s [BIBFRAME site](https://www.loc.gov/bibframe/) for more details. Specifications are included in the distribution in the [spec](spec/) directory. Changes of note:

* New Provision Activity conversion to separate encoded data in MARC 008 and transcribed data in MARC 26X. The 26X fields use new bflc properties bflc:simplePlace, bflc:simpleAgent and bflc:simpleDate to record literals. The 008 field uses existing bf:date and bf:place properties.

* Series fields (4XX and 8XX) will create BF Hubs.

* New Work types for Monograph, Serial, Series, Integrating, MusicAudio (subclass of Audio) and NonMusicAudio (subclass of Audio) created.

* 006 no longer converted.

* Added bflc:Uncontrolled for 720 conversion.

See the [NEWS](NEWS) file and the [updated specifications](spec/) for full details of changes. Changes from v1.7.1 in the specifications are marked in red.

## v1.7.1

Conversion updates based on specifications v1.7.1. See the Library of Congress' [BIBFRAME site](https://www.loc.gov/bibframe/) for more details. Specifications are included in this distribution in the [spec](spec/) directory. Changes of note:

* Deduping between 007 and 008, and other MARC fields.

* Convert MARC BibHubs to BF Hubs.

* Frequency notes changed to status resources. Use Note URIs not labels.

* Address issues #207 and #218.

See the [NEWS](NEWS) file and the [updated specifications](spec/) for full details of changes. Changes from v1.7 in the specifications are marked in red.

 
## v1.7.0

Conversion updates based on specifications v1.7. See the Library of Congress' [BIBFRAME site](https://www.loc.gov/bibframe/) for more details. Specifications are included in this distribution in the [spec](spec/) directory. Changes of note:

* Uniform titles in 130, 240, 6XX, and 8XX fields now generate stub "Hub" records rather than creating properties on the described Work or Instance.

* Major overhaul of punctuation handling, based on the [PCC Guidelines for Minimally Punctuated MARC Records](https://loc.gov/aba/pcc/documents/PCC-Guidelines-for-Minimally-Punctuated-MARC-Data-v.1.2.docx). See "Process 7" in the [Process0-7 doc](spec/ConvSpec-Process0-7-v1.7.docx).

* MARC 880 fields that are paired with 245, 250, 26X, and 490 fields are processed along with the standard MARC field, generating additional properties on the specified object with an xml:lang designation.

* Updates based on the BIBFRAME ontology v2.1.0.

See the [NEWS](NEWS) file and the [updated specifications](spec/) for full details of changes. Changes from v1.6 in the specifications are marked in red.

## v1.6.0

Conversion updates based on specifications v1.6. See the Library of Congress' [BIBFRAME site](https://www.loc.gov/bibframe/) for more details. Specifications are included in this distribution in the [spec](spec/) directory. Changes of note:

* Many duplicate properties generated by the LDR/fixed fields conversions, as well as data fields 336, 337, and 338, have been eliminated. In most cases only one of the applicable properties should be generated.

* More URIs have been added to the 007 and 006/008 conversions, which should result in the generation of fewer blank nodes.

* In many cases, an attempt is made to assign a URI to bf:Source and bf:assigner/bf:Agent nodes where appropriate.

* URIs have been added to the bf:source properties generated by MARC subject fields reflecting the subject thesaurus in use.

* There has been a major overhaul of processing for multiscript records (records with 880 fields). In particular:
    * xml:lang attributes can now be generated from ISO-15294 codes in the $6 as well as MARC-8 codes.
    * MARC 880 fields are now matched with their linked "regular" field using the occurrence number in the $6. This is done to allow either the vernacular or the Romanized field to be converted, based on the configuration in the [map880.xml](xsl/conf/map880.xml) configuration file. See the numeric subfields conversion specification for more details. The general strategy:
        * Unlinked fields (with occurrence "00" or no matching occurrence number) are always converted.
        * For identifier fields (010-099), the regular data field is preferred over the linked 880.
        * For authority-controlled fields, the regular data field is preferred over the linked 880, as vernacular versions of the strings should be available from the authority record.
        * For other fields, the 880 is preferred, with some exceptions.
        * The 245 represents a special case: _both_ the 245 and the linked 880 are converted, and the properties generated by both fields are assigned to the same subjects.

* Use of the `localfields` stylesheet parameter has expanded to accommodate more local processing specific to the Library of Congress. In particular:
    * `localfields` controls handling of bf:Item generation from the 050, 051, and other fields.
    * For fields with $5, `localfields` will only process fields if the value of $5 is "DLC".
    * `localfields` limits the processing of 856 and 859 fields to only a few matching URL patterns.
