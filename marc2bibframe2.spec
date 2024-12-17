%define distnum %(/usr/lib/rpm/redhat/dist.sh --distnum)
%define idmetaversion %(. ./IDMETA; echo $VERSION)

Summary: MARCXML to BIBFRAME2 conversion
Name: marc2bibframe2
Version: %{idmetaversion}
Release: 1.indexdata
License: Public Domain
Group: Applications/Internet
Source0: %{name}-%{version}.tar.gz
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
Requires: libxml2,libxslt

%description
marc2bibframe2 is an XSLT 1.0 application for converting MARCXML
records to RDF/XML, using the BIBFRAME 2.0 and MADSRDF ontologies.

%prep
%setup -q

%build

%install
rm -rf $RPM_BUILD_ROOT

mkdir -p ${RPM_BUILD_ROOT}/%{_datadir}/marc2bibframe2
cp -a xsl/* ${RPM_BUILD_ROOT}/%{_datadir}/marc2bibframe2
mkdir -p ${RPM_BUILD_ROOT}/%{_docdir}/marc2bibframe2

%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%{_datadir}/marc2bibframe2
%{_docdir}/marc2bibframe2
%doc NEWS README.md LICENSE
%docdir %{_docdir}/marc2bibframe2

%changelog
* Thu Dec 02 2024  Kevin Ford <kevinford@loc.gov> - 2.8.1-1.indexdata
- Release 2.8.1

* Thu Nov 21 2024  Kevin Ford <kevinford@loc.gov> - 2.8.0-1.indexdata
- Release 2.8.0

* Tues Aug 23 2024  Kevin Ford <kevinford@loc.gov> - 2.7.0-1.indexdata
- Release 2.7.0

* Tues Jun 18 2024  Kevin Ford <kevinford@loc.gov> - 2.6.0-1.indexdata
- Release 2.6.0

* Fri Jan 19 2024  Kevin Ford <kevinford@loc.gov> - 2.5.0-1.indexdata
- Release 2.5.0

* Wed Nov 22 2023  Kevin Ford <kevinford@loc.gov> - 2.4.0-1.indexdata
- Release 2.4.0

* Fri Jan 20 2023  Kevin Ford <kevinford@loc.gov> - 2.3.0-1.indexdata
- Release 2.3.0

* Thu Dec 08 2022  Kevin Ford <kevinford@loc.gov> - 2.2.1-1.indexdata
- Release 2.2.1

* Mon Nov 28 2022  Kevin Ford <kevinford@loc.gov> - 2.2.0-1.indexdata
- Release 2.2.0

* Tue Oct 18 2022  Kevin Ford <kevinford@loc.gov> - 2.1.0-1.indexdata
- Release 2.1.0

* Fri Sep 9 2022  Kevin Ford <kevinford@loc.gov> - 2.0.2-1.indexdata
- Release 2.0.2

* Tue Sep 6 2022  Wayne Schneider <wayne@indexdata.com> - 2.0.1-1.indexdata
- Release 2.0.1

* Mon Oct 25 2021 Wayne Schneider <wayne@indexdata.com> - 1.7.0-1.indexdata
- Release 1.7.0

* Mon Oct 11 2021 Wayne Schneider <wayne@indexdata.com> - 1.6.2-1.indexdata
- Release 1.6.2

* Mon Dec 14 2020 Wayne Schneider <wayne@indexdata.com> - 1.6.1-1.indexdata
- Release 1.6.1

* Fri Dec 4 2020 Wayne Schneider <wayne@indexdata.com> - 1.6.0-1.indexdata
- Release 1.6.0

* Thu Jan 30 2020 Wayne Schneider <wayne@indexdata.com> - 1.5.2-1.indexdata
- Release 1.5.2

* Thu Jun 13 2019 Wayne Schneider <wayne@indexdata.com> - 1.5.1-1.indexdata
- Release 1.5.1

* Wed Jun 12 2019 Wayne Schneider <wayne@indexdata.com> - 1.5.0-1.indexdata
- Release 1.5.0

* Fri Feb 15 2019 Wayne Schneider <wayne@indexdata.com> - 1.4.0-1.indexdata
- Release 1.4.0

* Fri Jun 15 2018 Wayne Schneider <wayne@indexdata.com> - 1.3.2-1.indexdata
- Release 1.3.2

* Sat Oct 7 2017 Wayne Schneider <wayne@indexdata.com> - 1.3.1-1.indexdata
- Release 1.3.1

* Sat Oct 7 2017 Wayne Schneider <wayne@indexdata.com> - 1.3.0-1.indexdata
- Release 1.3.0

* Thu Jun 15 2017 Wayne Schneider <wayne@indexdata.com> - 1.2.2-1.indexdata
- Release 1.2.2

* Tue Jun 13 2017 Wayne Schneider <wayne@indexdata.com> - 1.2.1-1.indexdata
- Release 1.2.1

* Mon Jun 12 2017 Wayne Schneider <wayne@indexdata.com> - 1.2.0-1.indexdata
- Release 1.2.0

* Thu Apr 6 2017 Wayne Schneider <wayne@indexdata.com> - 1.1.0-1.indexdata
- Release 1.1.0

* Thu Mar 16 2017 Wayne Schneider <wayne@indexdata.com> - 1.0.1-1.indexdata
- Release 1.0.1

* Thu Mar 9 2017 Wayne Schneider <wayne@indexdata.com> - 1.0.0-1.indexdata
- First public release.

* Sat Feb 18 2017 Wayne Schneider <wayne@indexdata.com> - 0.1.0-1.indexdata
- Initial build.

