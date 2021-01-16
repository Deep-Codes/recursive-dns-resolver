Program Flow:

1. Filters Empty and Lines with Comments
2. Splits each line and creates a list
3. Creating `dns_hash` with key being `RECORD TYPE`, `SOURCE`, `DESTINATION` and respective values being Arrays of them

4. `resolve` function

- Looks for the index of the SOURCE
- handles Unknown Alias and Domains
- checks `RECORD TYPE` with the help of Index

1. if the type is `CNAME` gets `DESTINATION` pushes it and calls the recursive function with the new domain(destination)

2. elsif the type comes out to be `A` this means it has found its ipv4 address so it pushes the domain.

3. returns the `lookup_chain`
