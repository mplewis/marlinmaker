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
end
