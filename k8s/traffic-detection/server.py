import logging
import os
import socket
import struct

import infer

logger = logging.getLogger(__name__)

MSG_INFER = 1
MSG_RESULT = 2
MSG_ERROR = 3

MSG_FORMAT = "!HB256p16p"
MSG_SIZE = struct.calcsize(MSG_FORMAT)

def format_error(msg_id, error_message):
    return struct.pack(
        "!HB256p16x",
        msg_id,
        MSG_ERROR,
        error_message.encode("ascii")
    )

def run_server(socket_path):

    sock = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
    sock.bind(socket_path)

    logger.info("Bound to %s" % socket_path)

    try:
        while True:

            msg, address = sock.recvfrom(MSG_SIZE)

            if address is None:
                logger.error("Client did not bind")
                continue

            try:
                msg_id, msg_type, msg_arg1, msg_arg2 = struct.unpack(
                    MSG_FORMAT,
                    msg
                )
            except struct.error:
                logger.exception("Received invalid message")
                continue

            if msg_type == MSG_INFER:
                try:
                    with open(msg_arg1, "rb") as image_file:
                        res1, res2 = infer.run_inference(
                            image_file, msg_arg2
                        )

                    sock.sendto(
                        struct.pack(
                            "!HBBH253xBd7x",
                            msg_id,
                            MSG_RESULT,
                            2,
                            res1,
                            8,
                            res2
                        ),
                        address
                    )
                    
                    logger.info("Ran inference for message %d" % msg_id)
                except (IOError, infer.InferenceError) as e:
                    logger.exception(
                        "Inference for message %d failed" % msg_id
                    )

                    sock.sendto(
                        format_error(msg_id, "Inference failed"),
                        address
                    )
            else:
                logger.error("Message %d was invalid" % msg_id)
                
                sock.sendto(
                    format_error(msg_id, "Invalid message"),
                    address
                )                    
    finally:
        os.unlink(socket_path)        

if __name__ == "__main__":
    socket_path = os.environ["SOCKET_PATH"]

    logging.basicConfig(
        level=logging.INFO,
    )
    
    run_server(socket_path)
