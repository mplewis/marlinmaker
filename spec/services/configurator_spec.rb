require 'rails_helper'

describe Configurator do
  describe '.generate' do
    subject { described_class.generate params }
    let(:lines) { subject.split "\n" }
    let(:params) {{
      board_name: 'CR10', # defcontents
      thermistor: 'v6_hotend', # defcontentsif
      lcd_language: 'fr', # defval
      ezabl_points: 10, # defval
      heaters_on_during_probing: true, # defif
      ezabl_outside_grid_compensation: false # defif, default: true
    }}

    it 'includes the correct items' do
      expect(subject).to include(
        '#define CR10',
        '#define V6_HOTEND',
        '#define LCD_LANGUAGE "fr"',
        '#define EZABL_POINTS 10',
        '#define HEATERS_ON_DURING_PROBING',
      )
      expect(subject).to_not include '#define EZABL_OUTSIDE_GRID_COMPENSATION'
      expect(lines.map(&:strip)).to_not include '#define'
    end
  end

  context 'validations' do
    let(:valid_params) {{
      board_name: 'CR10', # defcontents
      thermistor: 'v6_hotend', # defcontentsif
      lcd_language: 'fr', # defval
      ezabl_points: 10, # defval
      heaters_on_during_probing: true, # defif
      ezabl_outside_grid_compensation: false # defif, default: true
    }}

    let(:invalid_params) {{
      # no mandatory board name
      # non-boolean flag
      ezout_enable: 'no_thanks',
      # invalid thermistor type
      thermistor: 'new_fangled_heaty_boi',

      # some stuff that's actually valid
      lcd_language: 'fr',
      heaters_on_during_probing: true,
    }}

    describe '.errors' do
      subject { described_class.errors params }

      context 'with valid params' do
        let(:params) { valid_params }
        it { is_expected.to be_empty }
      end

      context 'with invalid params' do
        let(:params) { invalid_params }
        it { is_expected.to eql(
          board_name: ["Missing mandatory key :board_name"],
          ezout_enable:
            ['Value for key :ezout_enable must be true or false, got "no_thanks"'],
          thermistor: [
            <<~MSG.squish
              Value for key :thermistor must be one of
              ["v6_hotend", "th3d_hotend_thermistor", "th3d_bed_thermistor", "keenovo_tempsensor"],
              got "new_fangled_heaty_boi"
            MSG
          ],
        )}
      end
    end
  end
end
