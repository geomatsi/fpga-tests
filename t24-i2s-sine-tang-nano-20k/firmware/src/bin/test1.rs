#![no_main]
#![no_std]

use cortex_m as cm;
use cortex_m_rt::entry;
use cortex_m_semihosting::hprintln;
use panic_semihosting as _;
use rotary_encoder_embedded::{Direction, RotaryEncoder};
use stm32f4xx_hal::{
    gpio::Pull,
    pac,
    prelude::*,
    rcc,
    spi::{Mode, Phase, Polarity, Spi},
};

const FREQ_LO: u32 = 400;
const FREQ_HI: u32 = 1000;

#[entry]
fn main() -> ! {
    let dp = pac::Peripherals::take().unwrap();
    let cp = cm::Peripherals::take().unwrap();
    let mut rcc = dp
        .RCC
        .freeze(rcc::Config::hse(25.MHz()).sysclk(84.MHz()).pclk1(42.MHz()));

    let gpioa = dp.GPIOA.split(&mut rcc);
    let gpioc = dp.GPIOC.split(&mut rcc);
    let mut delay = cp.SYST.delay(&rcc.clocks);

    // LED

    let mut led = gpioc.pc13.into_push_pull_output();

    // SPI master

    let mut cs_n = gpioa.pa4.into_push_pull_output();
    cs_n.set_high();

    let sclk = gpioa.pa5.internal_resistor(Pull::Down);
    let miso = gpioa.pa6.internal_resistor(Pull::Down);
    let mosi = gpioa.pa7.internal_resistor(Pull::Down);

    let mut spi = Spi::new(
        dp.SPI1,
        (Some(sclk), Some(miso), Some(mosi)),
        Mode {
            polarity: Polarity::IdleLow,
            phase: Phase::CaptureOnFirstTransition,
        },
        1.MHz(),
        &mut rcc,
    );

    // KY-040 rotary encoder

    let clk = gpioa.pa12.into_pull_up_input();
    let dt = gpioa.pa11.into_pull_up_input();
    let button = gpioa.pa10.into_pull_up_input();
    let mut enc = RotaryEncoder::new(dt, clk).into_standard_mode();
    let mut button_pressed = false;

    //

    let mut tx = [0u8; 1];
    let mut rx = [0u8; 1];

    let mut freq = 600u32;
    let freq_delta = 5u32;

    hprintln!("FPGA I2S: initial frequency is {} Hz", freq);

    loop {
        match enc.update() {
            Direction::Anticlockwise => {
                freq = freq.saturating_add(freq_delta).clamp(FREQ_LO, FREQ_HI);

                tx[0] = (freq >> 2) as u8;
                cs_n.set_low();
                spi.transfer(&mut rx, &tx).unwrap();
                cs_n.set_high();

                hprintln!("> freq {} Hz", ((freq >> 2) << 2));
            }
            Direction::Clockwise => {
                freq = freq.saturating_sub(freq_delta).clamp(FREQ_LO, FREQ_HI);

                tx[0] = (freq >> 2) as u8;
                cs_n.set_low();
                spi.transfer(&mut rx, &tx).unwrap();
                cs_n.set_high();

                hprintln!("> freq {} Hz", ((freq >> 2) << 2));
            }
            Direction::None => {}
        }

        match button.is_low() {
            true => {
                if !button_pressed {
                    hprintln!("> button pressed...");
                    button_pressed = true;
                    led.toggle();
                }
            }
            false => {
                if button_pressed {
                    hprintln!("> button released...");
                    button_pressed = false;
                }
            }
        }

        delay.delay_ms(1);
    }
}
