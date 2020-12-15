// IORDACHE TIBERIU-MIHAI 322CD
#include <unistd.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

static int write_stdout(const char *token, int length)
{
	int rc;
	int bytes_written = 0;

	do {
		rc = write(1, token + bytes_written, length - bytes_written);
		if (rc < 0)
			return rc;

		bytes_written += rc;
	} while (bytes_written < length);

	return bytes_written;
}

// swaps 2 characters from a string
void swap(char* a, char* b) {
    char t = *a;
    *a = *b;
    *b = t;
}


// reverse a string
char* reverse(char* buffer, int i, int j) {
    while(1) {
        if (i > j) 
            break;
        
        swap(&buffer[i], &buffer[j]);

		++i;
		--j;
    }

    return buffer;
}

char* myitoa(int num_to_be_converted, char* buffer, int base) {
    // used long long to cover all the int min and max cases

	// convert the number to its absolute value
	long long number = llabs(num_to_be_converted);

	// iterator for buffer
    int i = 0;

    while(1) {
		// while loop ends when the numbers become 0
        if (number == 0)
            break;
        
		// calculate the rest
        int rest = number % base;

		// complete each char with the ascii code
        if (rest >= 10) 
            buffer[i++] = 65 + (rest - 10);
        else
            buffer[i++] = 48 + rest;
        
		// divide the number
        number /= base;
    }

	// special case: 
	// the while loop ended immediatly, it means the number is 0
    if (i == 0) 
        buffer[i++] = '0';

	// special case:
	// if the base is 10 and it is negative, we need to put
	// an '-' at the end so when it will be reversed it will 
	// be the firt char
    if (num_to_be_converted < 0 && base == 10)
        buffer[i++] = '-';

	// set the string terminator
    buffer[i] = '\0';

	// return the reversed string 
    return reverse(buffer, 0, i - 1);
}

char* myutoa(unsigned int num, char* str, int base) {
    // used to store the string before it will be reversed
	char buffer[17];

	int buffer_it = 0;
    int str_it = 0;

    while(1) {
		// while loop condition
		if (num <= 0)
			break;

		// calculate the rest
        int rest = num % base;

		// convert the rest into a char
        if (rest >= 10)
			buffer[buffer_it++] = rest - 10 + 'a';
            
        else
			buffer[buffer_it++] = rest + '0';

		// divide the number
        num /= base;	
    }

    --buffer_it;

	// reverse the string
    while(1) {
		// while loop condition
		if (buffer_it < 0)
			break;

        str[str_it++] = buffer[buffer_it--];
    }

	// add the string terminator
    str[str_it] = 0;

	// return the final string
    return str;
}

int iocla_printf(const char *format, ...)
{
	// the length of the final string that will be returned
	int result = 0;

	va_list args;

	va_start(args, format);

	// iterator for the format string
	char* it = (char*)format;
	
	int i = 0;

	// start the iteration in the string format
	while(1) {
		// while loop will stop when we get to the end of the string
		if (*(it + i) == '\0')
			break;

		// check if the current char is a specificator
		if (*(it + i) == '%') {
			// increment the position of iterator
			++i;

			// number of '%' occurences in the string
			int counter = 1;

			// second while loop to check if there are multiple
			// occurencies of '%'
            while(1) {
				// while loop will stop when we get to the end of the string
				// or when we stop getting the '%'
                if ((*(it + i) != '%') || (*(it + i) == '\0')) 
                    break;

				// incresase the counter as we keep getting '%'
				++counter;

				// if we get '%%' we will need to print only one
				if (counter == 2) {
					// allocate memory for the string to be printed
					char* string = malloc(2 * sizeof(*string));
					
					// allocation check
					if(string == NULL) {
						// Memory allocation failure
						exit(1);
					}
					
					// the first char will be the '%'
					*string = (char)*(it + i);

					// set the string terminator
					*(string + 1) = '\0';

					// print
					write_stdout(string, strlen(string));

					// free the string memory
					free(string);

					// increase the resulted string length
					++result;

					// restart the counter
					counter = 0;
				}
				
				// increment the position of iterator
				++i;			
            }

			// if the counter is still 0, then that means we simply
			// print the current char
			if (counter == 0) {
				// allocate memory for the string to be printed
				char* string = malloc(2 * sizeof(*string));

				// allocation check
				if (string == NULL) {
					// Memory allocation failure
					exit(1);
				}

				// set the first char to be the desired char 
				*string = (char)*(it + i);
				
				// set the string terminator
				*(string + 1) = '\0';

				// print
				write_stdout(string, strlen(string));
				
				// free the allocated memory for the string
				free(string);
				
				// increase the resulted string length
				++result;

				// increment the position of iterator
				++i;	
			}
			else {
				if (*(it + i) == 'd') {
					// int case

					// get the number from the args list
					int number = va_arg(args, int);
					
					// requied for the itoa function
					char buffer[(8 * sizeof(int)) + 1];

					// convert the number into string
					char* string = myitoa(number, buffer, 10);

					// print the string
					write_stdout(string, strlen(string));

					// increase the result
					result += strlen(string);
				}

				if (*(it + i) == 'u') {
					// unsigned int case

					// get the number from the args list
					unsigned int number = va_arg(args, unsigned int);

					// allocate memory for the string
					char* string = malloc(((8 * sizeof(unsigned int)) + 1) 
														* sizeof(*string));

					// allocation check
					if (string == NULL) {
						// Memory allocation failure
						exit(1);
					}

					// convert the number into string
					myutoa(number, string, 10);

					// print the string
					write_stdout(string, strlen(string));

					// increase the result
					result += strlen(string);

					// free the string allocated memory
					free(string);
				}

				if (*(it + i) == 'x') {
					// hexa case

					// get the number from the args list
					unsigned int number = va_arg(args, unsigned int);

					// allocate memory for the string
					char* string = malloc(((8 * sizeof(unsigned int)) + 1) 
														* sizeof(*string));

					// allocation check
					if (string == NULL) {
						// Memory allocation failure
						exit(1);
					}

					// convert the number into string, print, increase
					// the result, then free the string memory
					myutoa(number, string, 16);

					write_stdout(string, strlen(string));

					result += strlen(string);

					free(string);
				}

				if (*(it + i) == 'c') {
					// char case

					// get the char from the args list as an int
					int character = va_arg(args, int);

					// allocate memory for the string
					char* string = malloc(2 * sizeof(*string));

					if (string == NULL) {
						// Memory allocation failure
						exit(1);
					}

					// the first element of the string will be the 
					// char conversion of the character so it will 
					// be converted to the ASCII representation
					*string = (char)character;

					// set the string terminator
					*(string + 1) = '\0';
					
					write_stdout(string, strlen(string));
					
					result += strlen(string);

					free(string);
				}

				if (*(it + i) == 's') {
					// string case

					// get the string from the args list
					char* string = va_arg(args, char *);

					// print the string
					write_stdout(string, strlen(string));

					// increase
					result += strlen(string);
				}

				// increment the position of the iterator
				++i;
			}
		}
		else {
			// no specificator, we need to print the char

			// allocate memory for the string which will be printed
			char* string = malloc(2 * sizeof(*string));

			// allocation check
			if (string == NULL) {
				// Memory allocation failure
				exit(1);
			}

			// the first element of the string will be the char
			*string = (char)*(it + i);
			
			// set the string terminator
			*(string + 1) = '\0';

			// print the string
			write_stdout(string, strlen(string));
			
			// free the string memory
			free(string);
			
			// increase the result
			++result;

			// increment the position of the iterator
			++i;
		}
	}

	va_end(args);

	return result;
}
