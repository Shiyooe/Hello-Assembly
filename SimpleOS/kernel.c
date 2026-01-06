// kernel.c - Main kernel code
#define VGA_MEMORY 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;

uint16_t* vga_buffer = (uint16_t*)VGA_MEMORY;
int cursor_x = 0;
int cursor_y = 0;
uint8_t color = 0x0F; // White on black

void clear_screen() {
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga_buffer[i] = (color << 8) | ' ';
    }
    cursor_x = 0;
    cursor_y = 0;
}

void putchar(char c) {
    if (c == '\n') {
        cursor_x = 0;
        cursor_y++;
    } else {
        int pos = cursor_y * VGA_WIDTH + cursor_x;
        vga_buffer[pos] = (color << 8) | c;
        cursor_x++;
        if (cursor_x >= VGA_WIDTH) {
            cursor_x = 0;
            cursor_y++;
        }
    }
    
    if (cursor_y >= VGA_HEIGHT) {
        cursor_y = VGA_HEIGHT - 1;
        // Simple scroll
        for (int i = 0; i < VGA_WIDTH * (VGA_HEIGHT - 1); i++) {
            vga_buffer[i] = vga_buffer[i + VGA_WIDTH];
        }
        for (int i = 0; i < VGA_WIDTH; i++) {
            vga_buffer[VGA_WIDTH * (VGA_HEIGHT - 1) + i] = (color << 8) | ' ';
        }
    }
}

void print(const char* str) {
    while (*str) {
        putchar(*str++);
    }
}

void print_hex(uint32_t n) {
    char hex[] = "0123456789ABCDEF";
    print("0x");
    for (int i = 28; i >= 0; i -= 4) {
        putchar(hex[(n >> i) & 0xF]);
    }
}

void kernel_main() {
    clear_screen();
    
    color = 0x0A; // Green
    print("=================================\n");
    print("   Welcome to SimpleOS v1.0\n");
    print("=================================\n\n");
    
    color = 0x0F; // White
    print("Kernel loaded successfully!\n");
    print("Running in 32-bit protected mode\n\n");
    
    color = 0x0E; // Yellow
    print("System Information:\n");
    color = 0x0F;
    print("- VGA Text Mode: 80x25\n");
    print("- Memory: ");
    print_hex((uint32_t)vga_buffer);
    print("\n");
    
    color = 0x0B; // Cyan
    print("\nOS Features:\n");
    color = 0x0F;
    print("- Bootloader: Custom 16-bit\n");
    print("- Protected Mode: 32-bit\n");
    print("- VGA Driver: Text mode\n");
    print("- Language: Assembly + C\n");
    
    color = 0x0C; // Red
    print("\n\nSystem halted. Reboot to exit.\n");
    
    // Infinite loop
    while(1) {
        __asm__ __volatile__("hlt");
    }
}