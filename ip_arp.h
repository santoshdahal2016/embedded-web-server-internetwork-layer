//@{
#ifndef IP_ARP_H
#define IP_ARP_H
#include <avr/pgmspace.h>

// you must call this function once before you use any of the other functions:
extern void init_ip_arp(uint8_t *mymac,uint8_t *myip,uint8_t wwwp);
//
extern uint8_t eth_type_is_arp_and_my_ip(uint8_t *buf,uint16_t len);
extern uint8_t eth_type_is_ip_and_my_ip(uint8_t *buf,uint16_t len);
extern void make_arp_answer_from_request(uint8_t *buf);
extern void make_echo_reply_from_request(uint8_t *buf,uint16_t len);

#endif /* IP_ARP_UDP_TCP_H */
//@}
