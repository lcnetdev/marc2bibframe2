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

