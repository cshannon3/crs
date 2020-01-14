
import 'dart:math';



double K(double progress) {
  return sin(progress * (pi / 200));
}

double Z(double progress) {
  return cos(progress * (pi / 200));
}

double X(double progress) {
  return tan(progress * (pi / 200));
}

double rad(double progress) {
  return progress * (pi / 200);
}

double toProgress(double rad) {
  return rad * (200.0 / pi);
}

double progressFromZ(double zlength, double radius) {
  return toProgress(acos(zlength / radius));
}

double progressFromK(double klength, double radius) {
  return toProgress(asin(klength / radius));
}
