module Devices
  class CreateSeedData < Mutations::Command
    PRODUCT_LINES = {
      "express_1.0" => Devices::Seeders::ExpressOneZero,
      "genesis_1.2" => Devices::Seeders::GenesisOneTwo,
      "genesis_1.3" => Devices::Seeders::GenesisOneThree,
      "genesis_1.4" => Devices::Seeders::GenesisOneFour,
      "xl_1.0" => Devices::Seeders::XlOneZero,
      "xl_1.4" => Devices::Seeders::XlOneFour,
      "none" => Devices::Seeders::None,
    }

    COMMANDS = Devices::Seeders::Abstract.instance_methods(false).sort

    required do
      model :device
      string :product_line, in: PRODUCT_LINES.keys
    end

    def execute
      run_seeds!
    end

    def seeder
      @seeder ||= PRODUCT_LINES.fetch(product_line).new(device)
    end

    def run_seeds!
      COMMANDS.map { |cmd| seeder.send(cmd) }
    end
  end
end
