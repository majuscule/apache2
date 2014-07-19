#
# Copyright (c) 2014 OneHealth Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative '../../../kitchen/data/serverspec_helper'

property[:apache][:default_modules].each do |expected_module|
  describe "apache2::mod_#{expected_module}" do
    describe file("#{property[:apache][:dir]}/mods-available/#{expected_module}.load") do
      it { should be_file }
      it { should be_mode 644 }
      its(:content) { should match "LoadModule #{expected_module}_module #{property[:apache][:libexec_dir]}/mod_#{expected_module}.so\n" }
    end
    describe file("#{property[:apache][:dir]}/mods-enabled/#{expected_module}.load") do
      it { should be_linked_to "../mods-available/#{expected_module}.load" }
    end

    describe command("#{property[:apache][:binary]} -M") do
      it { should return_exit_status 0 }
      it { should return_stdout(/#{expected_module}_module/) }
    end
  end
end
