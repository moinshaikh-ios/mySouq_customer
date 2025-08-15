function calculate_checksum(N) {
    
    // convert input value to upper case
    strN = new String(N);
    strN = strN.toUpperCase();
    
    strHex = new String("0123456789ABCDEF");
    result = 0;
    fctr = 16;
    for (i=0; i<strN.length; i++) {
        if (strN.charAt(i) == " ") continue;
        v = strHex.indexOf(strN.charAt(i));
        if (v < 0) {
            result = -1;
            break;
        }
        result += v * fctr;
        
        if (fctr == 16)
            fctr = 1;
        else
            fctr = 16;
    }
    if (result < 0) {
        strResult = new String("Non-hex character entered");
    }
    else if (fctr == 1) {
        strResult = new String("Odd number of characters entered. e.g. correct value = aa aa");
    }
    else {
        // Calculate 2's complement
        result = (~(result & 0xff) + 1) & 0xFF;
        // Convert result to string
        //strResult = new String(result.toString());
        strResult = strHex.charAt(Math.floor(result/16)) + strHex.charAt(result%16);
        return strResult;
    }
    return "";
}
