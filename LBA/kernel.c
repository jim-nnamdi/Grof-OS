void main(){
    const char *msg = "Welcome to Grof operating system";
    volatile char *vga_mem = (volatile char *) 0xb8000;
    int msg_len = 0;
    while(msg[msg_len]) msg_len++;
    int cols = (80 - msg_len) / 2;
    int offset = (12 * 80 + cols) * 2;
    for(int i = 0; i < msg_len; ++i){
        vga_mem[offset + i * 2] = msg[i];
        vga_mem[offset + i * 2 + 1] = 0x1f;
    }
    while(1);
}