require 'spec_helper'

describe package('Microsoft Visual Studio Enterprise 2015') do
    it { should be_installed }
end

describe package('Microsoft .NET Framework 4.6 SDK') do
    it { should be_installed }
end

describe package('Microsoft Windows SDK for Windows 7 (7.1)') do
    it { should be_installed }
end

