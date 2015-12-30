require 'spec_helper'

describe 'ca_cert::update', :type => :class do
  context "on a Debian based OS" do
    let :facts do
      {
        :osfamily => 'Debian',
      }
    end

    it { is_expected.to contain_ca_cert__params }
    it { is_expected.not_to contain_exec('enable_ca_trust') }
    it { is_expected.to contain_exec('ca_cert_update').with(
      :command     => 'update-ca-certificates',
      :refreshonly => true,
    )}

  end
  context "on a RedHat based OS" do
    context "on RHEL 5" do
      let :facts do
        {
          :osfamily => 'RedHat',
          :operatingsystemmajrelease => '5',
        }
      end

      it { is_expected.to contain_ca_cert__params }
      it { is_expected.not_to contain_exec('enable_ca_trust') }
      it { is_expected.to contain_exec('ca_cert_update').with(
        :command     => 'c_rehash',
        :refreshonly => true,
      )}
    end

    context "on RHEL 6" do
      let :facts do
        {
          :osfamily => 'RedHat',
          :operatingsystemmajrelease => '6',
        }
      end

      it { is_expected.to contain_ca_cert__params }
      it { is_expected.to contain_exec('enable_ca_trust').with(
        :command => 'update-ca-trust enable',
      ) }
      it { is_expected.to contain_exec('ca_cert_update').with(
        :command     => 'update-ca-trust extract',
        :refreshonly => true,
      )}
    end
  end
end
