#![no_main]
#![no_std]

use cortex_m as cm;
use cortex_m_rt::entry;
use panic_semihosting as _;
use stm32f4xx_hal::{
    gpio::Pull,
    pac,
    prelude::*,
    rcc,
    spi::{Mode, Phase, Polarity, Spi},
};

#[entry]
fn main() -> ! {
    let dp = pac::Peripherals::take().unwrap();
    let cp = cm::Peripherals::take().unwrap();
    let mut rcc = dp.RCC.freeze(rcc::Config::hse(25.MHz()).sysclk(84.MHz()).pclk1(42.MHz()));

    let gpioa = dp.GPIOA.split(&mut rcc);
    let gpioc = dp.GPIOC.split(&mut rcc);
    let mut delay = cp.SYST.delay(&rcc.clocks);

    let mut led = gpioc.pc13.into_push_pull_output();

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

    let mut byte: u8 = 0;

    loop {
            // write returns once the byte has been clocked out (waits for RXNE)
            cs_n.set_low();
            spi.write(&[byte]).unwrap();
            cs_n.set_high();

            byte = byte.wrapping_add(1);

            delay.delay_ms(1000u32);
            led.toggle();
    }
}
