// lib/models/car_model.dart

class Car {
  final String id, name, brand, image, transmission, fuelType;
  final double price;
  final int seats;
  final bool isAvailable; // Naya field add kiya

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.image,
    required this.price,
    required this.transmission,
    required this.seats,
    required this.fuelType,
    required this.isAvailable, // Required kiya
  });
}

final List<Car> mockCars = List.generate(15, (index) {
  bool availability = (index == 3 || index == 7 || index == 12) ? false : true;

  return Car(
    id: '$index',
    name: ['Tesla S', 'BMW X5', 'Thar', 'Audi A6', 'Civic', 'Fortuner', 'Swift', 'Safari', 'Urus', 'Mustang', 'Verna', 'Innova', 'C-Class', 'Creta', 'Range Rover'][index],
    brand: ['Tesla', 'BMW', 'Mahindra', 'Audi', 'Honda', 'Toyota', 'Suzuki', 'Tata', 'Lamborghini', 'Ford', 'Hyundai', 'Toyota', 'Mercedes', 'Hyundai', 'Land Rover'][index],
    image: 'assets/images/car${(index) + 1}.jpeg',
    price: 1000.0 + (index * 30),
    transmission: index % 2 == 0 ? 'Auto' : 'Manual',
    seats: index == 2 ? 4 : 5,
    fuelType: index % 3 == 0 ? 'Electric' : 'Petrol',
    isAvailable: availability, 
  );
});