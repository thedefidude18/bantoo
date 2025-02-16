extension DurationExtension on Duration? {


  String printDuration() {
    if(this == null){
      return "00:00";
    }
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(this!.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(this!.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  String printDurationWithHours() {
    if(this == null){
      return "00:00:00";
    }
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(this!.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(this!.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(this!.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}