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
cp -a spec/* ${RPM_BUILD_ROOT}/%{_docdir}/marc2bibframe2

%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%{_datadir}/marc2bibframe2
%{_docdir}/marc2bibframe2
%doc NEWS README.md
%docdir %{_docdir}/marc2bibframe2

%changelog
* Sat Feb 18 2017 Wayne Schneider <wayne@indexdata.com> - 0.1.0-1.indexdata
- Initial build.

