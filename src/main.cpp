#include <Arduino.h>
#include <Adafruit_Sensor.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <DHT.h>
#include <DHT_U.h>

#define SERVICE_UUID "4f3af719-2cbc-454e-bfd1-9e260b01b40d"
#define CHARACTERISTIC_UUID "7107e54a-d118-45b2-aa04-4f2464debf41"

#define US_ONE_SECOND 1000000
#define MS_BLUETOOTH_ON 30000
#define MS_BETWEEN_MEASUREMENTS (MS_BLUETOOTH_ON / 10)

RTC_DATA_ATTR int bootCount = 0;

DHT dht(22, DHT11);
float soilMoisture = 0.0;
float humidity;
float temperature;

BLECharacteristic *characteristic;

void printWakeupReason();
void initBluetooth();
void measure();

void setup()
{
  esp_sleep_enable_timer_wakeup(US_ONE_SECOND * 60);

  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, 0);

  Serial.begin(9600);
  dht.begin();
  initBluetooth();
  printWakeupReason();
}

void loop()
{
  for (int i = 0; i < MS_BLUETOOTH_ON; i += MS_BETWEEN_MEASUREMENTS)
  {
    measure();
    delay(MS_BETWEEN_MEASUREMENTS);
  }
  esp_deep_sleep_start();
}

void initBluetooth()
{
  BLEDevice::init("Plant: Emerson");
  BLEServer *server = BLEDevice::createServer();
  BLEService *service = server->createService(SERVICE_UUID);
  characteristic = service->createCharacteristic(
      CHARACTERISTIC_UUID,
      BLECharacteristic::PROPERTY_READ);

  service->start();
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
}

void printWakeupReason()
{
  switch (esp_sleep_get_wakeup_cause())
  {
  case ESP_SLEEP_WAKEUP_EXT0:
    Serial.println("Wakeup caused by external signal using RTC_IO");
    break;
  case ESP_SLEEP_WAKEUP_EXT1:
    Serial.println("Wakeup caused by external signal using RTC_CNTL");
    break;
  case ESP_SLEEP_WAKEUP_TIMER:
    Serial.println("Wakeup caused by timer");
    break;
  case ESP_SLEEP_WAKEUP_TOUCHPAD:
    Serial.println("Wakeup caused by touchpad");
    break;
  case ESP_SLEEP_WAKEUP_ULP:
    Serial.println("Wakeup caused by ULP program");
    break;
  default:
    Serial.printf("Wakeup was not caused by deep sleep: %d\n", esp_sleep_get_wakeup_cause());
    break;
  }
}

void measure()
{
  soilMoisture = map(analogRead(32), 3120, 1270, 0, 100);
  humidity = dht.readHumidity();
  temperature = dht.readTemperature();

  auto measurements = String(temperature) + "," + String(humidity) + "," + String(soilMoisture);
  characteristic->setValue(measurements.c_str());
}
