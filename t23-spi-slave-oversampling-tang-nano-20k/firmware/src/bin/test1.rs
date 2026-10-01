#![no_main]
#![no_std]

use cortex_m as cm;
use cortex_m_rt::entry;
use cortex_m_semihosting::hprintln;
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
    let mut rcc = dp
        .RCC
        .freeze(rcc::Config::hse(25.MHz()).sysclk(84.MHz()).pclk1(42.MHz()));

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

    let mut tx = [0u8; 1];
    let mut rx = [0u8; 1];

    loop {
        // full duplex: send one byte on MOSI, receive one byte from MISO
        cs_n.set_low();
        spi.transfer(&mut rx, &tx).unwrap();
        cs_n.set_high();

        hprintln!("tx: 0x{:02x} rx: 0x{:02x}", tx[0], rx[0]);

        tx[0] = tx[0].wrapping_add(1);

        delay.delay_ms(1000u32);
        led.toggle();
    }
}
